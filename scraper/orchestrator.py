"""Orchestrator: coordinates schedule fetching, scraping, and database insertion."""

import argparse
import logging
from datetime import datetime as dt, timedelta as td

from sqlalchemy import create_engine

import db
from constants import LEAGUE_ID, SPORT_ID
from constants.table_names import STG_OFFICIALS
from core.config import settings
from pipeline import ChunkResult, scrape_chunk
from scrapers import People, Transactions
from scheduler import get_schedule

logger = logging.getLogger(__name__)


def _scrape_and_insert_chunk(
    chunk: ChunkResult,
    engine,
    seen_ppl: set,
    seen_officials: set,
    seen_teams: set,
    people_scraper: People,
) -> None:
    """Insert all datasets from a single chunk into the database."""
    for scraper in (chunk.ctx, chunk.box, chunk.play):
        for table_name, dataset in scraper.datasets.items():
            db.insert_dataset(dataset, engine, table_name)

    box = chunk.box
    chunk_ppl = set(box.player_game_info["playerId"])
    chunk_officials = set(box.official_types["officialId"])

    new_ppl = chunk_ppl - seen_ppl
    new_officials = chunk_officials - seen_officials
    seen_ppl |= chunk_ppl
    seen_officials |= chunk_officials

    people_scraper.set_data(new_ppl)
    for table_name, dataset in people_scraper.datasets.items():
        db.insert_dataset(dataset, engine, table_name)

    people_scraper.set_data(new_officials)
    db.insert_dataset(people_scraper.people, engine, STG_OFFICIALS)

    ctx = chunk.ctx
    seen_teams.update(ctx.context_metrics["homeId"])


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
    seen_teams: set = set()
    people_scraper = People()
    transaction_scraper = Transactions()

    for chunk_start in range(0, len(game_pks), batch_size):
        chunk_games = game_pks[chunk_start: chunk_start + batch_size]
        chunk_num = (chunk_start + batch_size) // batch_size
        logger.info("Chunk %d: scraping %d games.", chunk_num, len(chunk_games))

        chunk = scrape_chunk(chunk_games, major_league, major_league_id, max_workers)

        _scrape_and_insert_chunk(
            chunk, engine,
            seen_ppl, seen_officials, seen_teams, people_scraper,
        )

    if seen_teams:
        valid_teams = {t for t in seen_teams if t}
        transaction_scraper.set_data(valid_teams, start_date=start_date, end_date=end_date)
        for table_name, dataset in transaction_scraper.datasets.items():
            db.insert_dataset(dataset, engine, table_name)


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
