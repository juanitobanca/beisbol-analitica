"""URL builders for every MLB Stats API endpoint used by the scrapers."""

from .config import settings


def _base() -> str:
    return settings.base_url


def game_url(game_pk: int, endpoint: str) -> str:
    """Return the URL for a game-scoped endpoint (boxscore, playByPlay, etc.)."""
    return f"{_base()}/game/{game_pk}/{endpoint}"


def people_url(person_id: int) -> str:
    """Return the URL for a single person."""
    return f"{_base()}/people/{person_id}"


def people_batch_url(person_ids: list[int]) -> str:
    """Return the URL for a batch of people by ID."""
    ids = ",".join(str(i) for i in person_ids)
    return f"{_base()}/people?personIds={ids}"


def schedule_url(query_string: str) -> str:
    """Return the URL for the schedule endpoint.

    Args:
        query_string: Raw query string, e.g. ``"sportId=1&startDate=2024-04-01&endDate=2024-04-30"``.
    """
    return f"{_base()}/schedule?{query_string}"


def transactions_url(team_id: int, start_date: str, end_date: str) -> str:
    """Return the URL for team transactions within a date range."""
    return f"{_base()}/transactions?teamId={team_id}&startDate={start_date}&endDate={end_date}"
