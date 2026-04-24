"""Orchestrator: coordinates schedule fetching, scraping, and database insertion."""

import argparse
import logging
from datetime import datetime as dt, timedelta as td

from sqlalchemy import create_engine

import db_writer as db
from config import settings
from mappings import LEAGUE_ID, SPORT_ID
from people import People
from pipeline import scrape_chunk
from scheduler import get_schedule
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


def _scrape_and_insert_chunk(
    chunk: "pipeline.ChunkResult",  # noqa: F821 — avoid circular import in type hint
    engine,
    start_date: str,
    end_date: str,
    seen_ppl: set,
    seen_officials: set,
    people_scraper: People,
    transaction_scraper: Transactions,
) -> None:
    """Insert all datasets from a single chunk into the database."""
    box, play, ctx = chunk.box, chunk.play, chunk.ctx

    db.insert_dataset(ctx.context_metrics,        engine, STG_GAME_CONTEXT)
    db.insert_dataset(box.info,                   engine, STG_BOX_INFO)
    db.insert_dataset(box.official_types,          engine, STG_BOX_OFFICIALS)
    db.insert_dataset(box.team_batting,            engine, STG_BOX_TEAM_BATTING)
    db.insert_dataset(box.team_pitching,           engine, STG_BOX_TEAM_PITCHING)
    db.insert_dataset(box.team_fielding,           engine, STG_BOX_TEAM_FIELDING)
    db.insert_dataset(box.player_batting,          engine, STG_BOX_PLAYER_BATTING)
    db.insert_dataset(box.player_pitching,         engine, STG_BOX_PLAYER_PITCHING)
    db.insert_dataset(box.player_fielding,         engine, STG_BOX_PLAYER_FIELDING)
    db.insert_dataset(box.team_batting_order,      engine, STG_BOX_TEAM_BATTING_ORDER)
    db.insert_dataset(box.team,                    engine, STG_BOX_TEAM)
    db.insert_dataset(box.player_game_positions,   engine, STG_BOX_PLAYER_GAME_POSITIONS)
    db.insert_dataset(box.player_game_info,        engine, STG_BOX_PLAYER_GAME_INFO)
    db.insert_dataset(play.atbat,                  engine, STG_PLAY_ATBAT)
    db.insert_dataset(play.runner,                 engine, STG_PLAY_RUNNER)
    db.insert_dataset(play.credit,                 engine, STG_PLAY_CREDIT)
    db.insert_dataset(play.pitch,                  engine, STG_PLAY_PITCH)
    db.insert_dataset(play.action,                 engine, STG_PLAY_ACTION)
    db.insert_dataset(play.pickoff,                engine, STG_PLAY_PICKOFF)

    chunk_ppl = set(box.player_game_info["playerId"])
    chunk_officials = set(box.official_types["officialId"])

    new_ppl = chunk_ppl - seen_ppl
    new_officials = chunk_officials - seen_officials
    seen_ppl |= chunk_ppl
    seen_officials |= chunk_officials

    people_scraper.set_data(new_ppl)
    db.insert_dataset(people_scraper.people, engine, STG_PLAYERS)

    people_scraper.set_data(new_officials)
    db.insert_dataset(people_scraper.people, engine, STG_OFFICIALS)

    tm_set = set(ctx.context_metrics["homeId"])
    transaction_scraper.set_data(tm_set, start_date=start_date, end_date=end_date)
    db.insert_dataset(transaction_scraper.transactions, engine, STG_TRANSACTIONS)


def run(
    game_pks: list[int],
    batch_size: int,
    engine,
    start_date: str,
    end_date: str,
    major_league: str,
    major_league_id: int,
    max_workers: int = 10,
) -> None:
    """Scrape all games in batches and persist results to the database."""
    logger.info("Starting pipeline for %d games.", len(game_pks))

    seen_ppl: set = set()
    seen_officials: set = set()
    people_scraper = People()
    transaction_scraper = Transactions()

    for chunk_start in range(0, len(game_pks), batch_size):
        chunk_games = game_pks[chunk_start: chunk_start + batch_size]
        chunk_num = (chunk_start + batch_size) // batch_size
        logger.info("Chunk %d: scraping %d games.", chunk_num, len(chunk_games))

        chunk = scrape_chunk(chunk_games, major_league, major_league_id, max_workers)

        _scrape_and_insert_chunk(
            chunk, engine, start_date, end_date,
            seen_ppl, seen_officials, people_scraper, transaction_scraper,
        )


if __name__ == "__main__":
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    default_date = (dt.today() - td(1)).strftime("%Y_%m_%d")

    parser = argparse.ArgumentParser(description="MLB Stats API Scrapper")
    parser.add_argument("--con", default=settings.default_db_connection)
    parser.add_argument("--date", default=default_date, help="Date format: YYYY_MM_DD")
    parser.add_argument("--startDate", dest="start_date", default=None, help="Date format: YYYY_MM_DD")
    parser.add_argument("--endDate", dest="end_date", default=None, help="Date format: YYYY_MM_DD")
    parser.add_argument("--batch", default=settings.default_batch_size, type=int)
    parser.add_argument("--lg", default=None, help="League code (e.g. MLB, LMB, SDC)")
    parser.add_argument("--workers", default=settings.default_workers, type=int)

    args = parser.parse_args()

    major_league = args.lg
    major_league_id = LEAGUE_ID[args.lg]
    sport_id = SPORT_ID[args.lg]

    engine = create_engine(args.con)

    game_pks = get_schedule(args.date, args.start_date, args.end_date, sport_id, major_league_id)
    run(
        game_pks, args.batch, engine,
        args.start_date, args.end_date,
        major_league, major_league_id,
        max_workers=args.workers,
    )
