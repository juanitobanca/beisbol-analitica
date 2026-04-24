"""Orchestrator for scraping MLB Stats API data and inserting into a database."""

import argparse
import logging
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime as dt, timedelta as td
from typing import Any

import pandas as pd
from sqlalchemy import create_engine

import const as c
from base_scraper import Dataset
from boxscore import Boxscore
from context_metrics import ContextMetrics
from config import settings
from dataset import Dataset
from endpoints import schedule_url
from http_client import http_client
from mappings import LEAGUE_ID, SPORT_ID
from people import People
from play_by_play import PlayByPlay
from table_names import (
    STG_TRANSACTIONS, STG_GAME_CONTEXT,
    STG_BOX_TEAM_BATTING, STG_BOX_TEAM_PITCHING, STG_BOX_TEAM_FIELDING,
    STG_BOX_PLAYER_BATTING, STG_BOX_PLAYER_PITCHING, STG_BOX_PLAYER_FIELDING,
    STG_PLAYERS, STG_OFFICIALS,
    STG_BOX_TEAM_BATTING_ORDER, STG_BOX_TEAM, STG_BOX_PLAYER_GAME_POSITIONS,
    STG_BOX_PLAYER_GAME_INFO, STG_BOX_INFO, STG_BOX_OFFICIALS,
    STG_PLAY_ATBAT, STG_PLAY_RUNNER, STG_PLAY_CREDIT,
    STG_PLAY_PITCH, STG_PLAY_ACTION, STG_PLAY_PICKOFF,
)
from transactions import Transactions

logger = logging.getLogger(__name__)


def _merge_dicts(base: Dataset, incoming: Dataset) -> None:
    """Merge incoming dataset into base by extending each list."""
    for key in base:
        base[key].extend(incoming[key])


def _fetch_game(
    game_pk: int, major_league: str, major_league_id: int
) -> tuple[Boxscore, PlayByPlay, ContextMetrics]:
    """Download and parse all 3 endpoints for a single game (thread-safe)."""
    box = Boxscore()
    box.set_data([game_pk])

    play = PlayByPlay()
    play.set_data([game_pk])

    ctx = ContextMetrics()
    ctx.set_data([game_pk], major_league, major_league_id)

    return box, play, ctx


def get_schedule(
    date: str | None,
    start_date: str | None,
    end_date: str | None,
    sport_id: int,
    league_id: int,
) -> list[int]:
    """Fetch game PKs from the MLB schedule API."""
    logger.info("Getting schedules.")

    games: set[int] = set()

    league_param = "" if league_id == 1 else f"&leagueId={league_id}"

    if start_date and end_date:
        parsing_arg = f"sportId={sport_id}{league_param}&startDate={start_date}&endDate={end_date}"
    elif date:
        parsing_arg = f"sportId={sport_id}{league_param}&date={date}"
    else:
        parsing_arg = f"sportId={sport_id}{league_param}"

    schedule = http_client.get_json(schedule_url(parsing_arg))

    for d in schedule["dates"]:
        for g in d["games"]:
            games.add(g["gamePk"])

    logger.info("Done getting schedules. Found %d games.", len(games))

    return list(games)


def init_connection(connection_string: str) -> Any:
    """Initialize a SQLAlchemy database engine."""
    logger.info("Initializing database connection.")
    return create_engine(connection_string)


def insert_to_database(
    dataframe: pd.DataFrame,
    engine: Any,
    table_name: str,
    max_retries: int = 1,
) -> None:
    """Insert a DataFrame into the database, retrying up to *max_retries* times.

    Raises:
        RuntimeError: if all retry attempts are exhausted.
    """
    logger.info(f"{table_name}: Inserting {len(dataframe)} records into database." )

    last_exc: Exception | None = None

    for attempt in range(1, max_retries + 1):
        try:
            dataframe.to_sql(name=table_name, con=engine, if_exists="append", index=False)
            return
        except Exception as exc:
            last_exc = exc
            logger.error(
                "%s: Insert attempt %d/%d failed: %s",
                table_name,
                attempt,
                max_retries,
                exc,
            )
            if attempt < max_retries:
                time.sleep(settings.retry_delay_seconds)

    raise RuntimeError(
        f"{table_name}: all {max_retries} insert attempts exhausted"
    ) from last_exc


def to_pandas(data: Dataset) -> pd.DataFrame:
    """Convert a dataset dict to a pandas DataFrame."""
    return pd.DataFrame.from_dict(data)


def scrape_and_insert_data(
    game_pks: list[int],
    batch_size: int,
    engine: Any,
    start_date: str,
    end_date: str,
    major_league: str,
    major_league_id: int,
    max_workers: int = 10,
) -> None:
    """Scrape all data for the given games and insert into the database in chunks."""
    logger.info("Starting scrape and insert for %d games.", len(game_pks))

    seen_ppl: set = set()
    seen_officials: set = set()

    people_scraper = People()
    transaction_scraper = Transactions()

    for chunk_start in range(0, len(game_pks), batch_size):
        chunk_games = game_pks[chunk_start : chunk_start + batch_size]
        logger.info("Chunk %d: Starting logic.", (chunk_start + batch_size) // batch_size)

        box_acc = Boxscore()
        play_acc = PlayByPlay()
        cnt = ContextMetrics()

        with ThreadPoolExecutor(max_workers=max_workers) as pool:
            futures = {pool.submit(_fetch_game, gk, major_league, major_league_id): gk for gk in chunk_games}
            for future in as_completed(futures):
                gk = futures[future]
                try:
                    fetched_box, fetched_play, fetched_ctx = future.result()
                except Exception as e:
                    logger.error("Game %s failed: %s", gk, e)
                    continue

                for attr in (
                    "info", "official_types", "team", "team_batting", "team_pitching",
                    "team_fielding", "team_batting_order", "player_batting",
                    "player_pitching", "player_fielding", "player_game_info",
                    "player_game_positions",
                ):
                    _merge_dicts(getattr(box_acc, attr), getattr(fetched_box, attr))

                for attr in ("atbat", "runner", "credit", "pitch", "action", "pickoff"):
                    _merge_dicts(getattr(play_acc, attr), getattr(fetched_play, attr))

                _merge_dicts(cnt.context_metrics, fetched_ctx.context_metrics)

        chunk_ppl = set(box_acc.player_game_info["playerId"])
        chunk_officials = set(box_acc.official_types["officialId"])

        new_ppl = chunk_ppl - seen_ppl
        new_officials = chunk_officials - seen_officials

        seen_ppl |= chunk_ppl
        seen_officials |= chunk_officials

        insert_to_database(to_pandas(cnt.context_metrics), engine, STG_GAME_CONTEXT)
        insert_to_database(to_pandas(box_acc.info), engine, STG_BOX_INFO)
        insert_to_database(to_pandas(box_acc.official_types), engine, STG_BOX_OFFICIALS)

        insert_to_database(to_pandas(box_acc.team_batting), engine, STG_BOX_TEAM_BATTING)
        insert_to_database(to_pandas(box_acc.team_pitching), engine, STG_BOX_TEAM_PITCHING)
        insert_to_database(to_pandas(box_acc.team_fielding), engine, STG_BOX_TEAM_FIELDING)

        insert_to_database(to_pandas(box_acc.player_batting), engine, STG_BOX_PLAYER_BATTING)
        insert_to_database(to_pandas(box_acc.player_pitching), engine, STG_BOX_PLAYER_PITCHING)
        insert_to_database(to_pandas(box_acc.player_fielding), engine, STG_BOX_PLAYER_FIELDING)

        insert_to_database(to_pandas(box_acc.team_batting_order), engine, STG_BOX_TEAM_BATTING_ORDER)
        insert_to_database(to_pandas(box_acc.team), engine, STG_BOX_TEAM)
        insert_to_database(to_pandas(box_acc.player_game_positions), engine, STG_BOX_PLAYER_GAME_POSITIONS)
        insert_to_database(to_pandas(box_acc.player_game_info), engine, STG_BOX_PLAYER_GAME_INFO)

        insert_to_database(to_pandas(play_acc.atbat), engine, STG_PLAY_ATBAT)
        insert_to_database(to_pandas(play_acc.runner), engine, STG_PLAY_RUNNER)
        insert_to_database(to_pandas(play_acc.credit), engine, STG_PLAY_CREDIT)
        insert_to_database(to_pandas(play_acc.pitch), engine, STG_PLAY_PITCH)
        insert_to_database(to_pandas(play_acc.action), engine, STG_PLAY_ACTION)
        insert_to_database(to_pandas(play_acc.pickoff), engine, STG_PLAY_PICKOFF)

        people_scraper.set_data(new_ppl)
        insert_to_database(to_pandas(people_scraper.people), engine, STG_PLAYERS)

        people_scraper.set_data(new_officials)
        insert_to_database(to_pandas(people_scraper.people), engine, STG_OFFICIALS)

        tm_set = set(cnt.context_metrics["homeId"])
        transaction_scraper.set_data(tm_set, start_date=start_date, end_date=end_date)
        insert_to_database(to_pandas(transaction_scraper.transactions), engine, STG_TRANSACTIONS)


if __name__ == "__main__":
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    date = dt.today() - td(1)
    date_str = date.strftime("%Y_%m_%d")

    parser = argparse.ArgumentParser(description="MLB Stats API Scrapper")
    parser.add_argument("--con", default=settings.default_db_connection)
    parser.add_argument("--date", default=date_str, help="Date Format: YYYY_MM_DD")
    parser.add_argument("--startDate", dest="start_date", default=None, help="Date Format: YYYY_MM_DD")
    parser.add_argument("--endDate", dest="end_date", default=None, help="Date Format: YYYY_MM_DD")
    parser.add_argument("--batch", default=settings.default_batch_size, type=int)
    parser.add_argument("--lg", default=None, help="League code (e.g. MLB, LMB, SDC)")
    parser.add_argument("--workers", default=settings.default_workers, type=int, help="Concurrent threads")

    args = parser.parse_args()

    major_league = args.lg
    major_league_id = LEAGUE_ID[args.lg]
    sport_id = SPORT_ID[args.lg]

    con = init_connection(args.con)

    d = get_schedule(args.date, args.start_date, args.end_date, sport_id, major_league_id)
    scrape_and_insert_data(
        d, args.batch, con, args.start_date, args.end_date,
        major_league, major_league_id, max_workers=args.workers,
    )
