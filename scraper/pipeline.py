"""Concurrent scraping pipeline: fetches and merges game data across threads."""

import logging
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass

from scrapers import Boxscore, ContextMetrics, PlayByPlay
from scrapers.base import BaseScraper

logger = logging.getLogger(__name__)


@dataclass
class ChunkResult:
    """Holds all scraped datasets for a batch of games."""
    box: Boxscore
    play: PlayByPlay
    ctx: ContextMetrics
    failed_game_pks: list[int]


def _merge_scraper(accumulator: BaseScraper, fetched: BaseScraper) -> None:
    """Merge all registered datasets from *fetched* into *accumulator*."""
    for table_name, dataset in accumulator.datasets.items():
        for key in dataset:
            dataset[key].extend(fetched.datasets[table_name][key])


def _fetch_game(
    game_pk: int,
    major_league: str,
    major_league_id: int,
) -> tuple[Boxscore, PlayByPlay, ContextMetrics]:
    """Scrape all three endpoints for a single game. Designed to run in a thread."""
    box = Boxscore()
    box.set_data([game_pk])

    play = PlayByPlay()
    play.set_data([game_pk])

    ctx = ContextMetrics()
    ctx.set_data([game_pk], major_league, major_league_id)

    return box, play, ctx


def scrape_chunk(
    game_pks: list[int],
    major_league: str,
    major_league_id: int,
    max_workers: int,
) -> ChunkResult:
    """Concurrently scrape a list of games and return merged results.

    Args:
        game_pks:        Game PKs to scrape in this chunk.
        major_league:    League code string (e.g. "MLB").
        major_league_id: Numeric league identifier.
        max_workers:     Thread pool size.

    Returns:
        A :class:`ChunkResult` with all datasets merged and ready for insertion.
    """
    box_acc = Boxscore()
    play_acc = PlayByPlay()
    ctx_acc = ContextMetrics()
    failed: list[int] = []

    with ThreadPoolExecutor(max_workers=max_workers) as pool:
        futures = {
            pool.submit(_fetch_game, gk, major_league, major_league_id): gk
            for gk in game_pks
        }
        for future in as_completed(futures):
            gk = futures[future]
            try:
                fetched_box, fetched_play, fetched_ctx = future.result()
            except Exception as exc:
                logger.error("Game %s failed: %s", gk, exc)
                failed.append(gk)
                continue

            _merge_scraper(box_acc, fetched_box)
            _merge_scraper(play_acc, fetched_play)
            _merge_scraper(ctx_acc, fetched_ctx)

    if failed:
        logger.warning(
            "Chunk finished with %d/%d games failed: %s",
            len(failed), len(game_pks), failed,
        )

    return ChunkResult(box=box_acc, play=play_acc, ctx=ctx_acc, failed_game_pks=failed)
