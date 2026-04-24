"""Concurrent scraping pipeline: fetches and merges game data across threads."""

import logging
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass

from core.dataset import Dataset
from scrapers import Boxscore, ContextMetrics, PlayByPlay

logger = logging.getLogger(__name__)


@dataclass
class ChunkResult:
    """Holds all scraped datasets for a batch of games."""
    box: Boxscore
    play: PlayByPlay
    ctx: ContextMetrics


def _merge_datasets(base: Dataset, incoming: Dataset) -> None:
    """Extend each list in *base* with the corresponding list from *incoming*."""
    for key in base:
        base[key].extend(incoming[key])


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


def _merge_into_accumulator(
    box_acc: Boxscore,
    play_acc: PlayByPlay,
    ctx_acc: ContextMetrics,
    fetched_box: Boxscore,
    fetched_play: PlayByPlay,
    fetched_ctx: ContextMetrics,
) -> None:
    """Merge a single game's results into the chunk accumulators."""
    for attr in (
        "info", "official_types", "team", "team_batting", "team_pitching",
        "team_fielding", "team_batting_order", "player_batting",
        "player_pitching", "player_fielding", "player_game_info",
        "player_game_positions",
    ):
        _merge_datasets(getattr(box_acc, attr), getattr(fetched_box, attr))

    for attr in ("atbat", "runner", "credit", "pitch", "action", "pickoff"):
        _merge_datasets(getattr(play_acc, attr), getattr(fetched_play, attr))

    _merge_datasets(ctx_acc.context_metrics, fetched_ctx.context_metrics)


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
                continue

            _merge_into_accumulator(box_acc, play_acc, ctx_acc, fetched_box, fetched_play, fetched_ctx)

    return ChunkResult(box=box_acc, play=play_acc, ctx=ctx_acc)
