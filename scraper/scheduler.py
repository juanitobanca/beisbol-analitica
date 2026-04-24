"""Fetches game PKs from the MLB Stats API schedule endpoint."""

import logging

from core.endpoints import schedule_url
from core.http_client import http_client

logger = logging.getLogger(__name__)


def get_schedule(
    date: str | None,
    start_date: str | None,
    end_date: str | None,
    sport_id: int,
    league_id: int,
) -> list[int]:
    """Return all game PKs matching the given date range and league.

    Args:
        date:       Single date (used when start_date/end_date are absent).
        start_date: Range start date.
        end_date:   Range end date.
        sport_id:   MLB Stats API sport identifier.
        league_id:  MLB Stats API league identifier.

    Returns:
        Deduplicated list of game PKs.
    """
    logger.info("Getting schedules.")

    league_param = "" if league_id == 1 else f"&leagueId={league_id}"

    if start_date and end_date:
        query = f"sportId={sport_id}{league_param}&startDate={start_date}&endDate={end_date}"
    elif date:
        query = f"sportId={sport_id}{league_param}&date={date}"
    else:
        query = f"sportId={sport_id}{league_param}"

    schedule = http_client.get_json(schedule_url(query))

    games: set[int] = {
        g["gamePk"]
        for d in schedule["dates"]
        for g in d["games"]
    }

    logger.info("Done getting schedules. Found %d games.", len(games))
    return list(games)
