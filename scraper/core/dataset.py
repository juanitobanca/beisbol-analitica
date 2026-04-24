"""Dataset utilities shared across all scrapers."""

from typing import Any

Dataset = dict[str, list[Any]]


def create_dataset(fields: list[str], meta_fields: list[str] | None) -> Dataset:
    """Build an empty dataset dict with one empty list per field name.

    Args:
        fields:      Domain fields (stats, attributes, etc.).
        meta_fields: Optional metadata fields prepended to every row
                     (e.g. ``["gamePk", "teamId"]``).
    """
    dataset: Dataset = {}
    if meta_fields:
        for field in meta_fields:
            dataset[field] = []
    for field in fields:
        dataset[field] = []
    return dataset


def json_is_valid(json_data: dict) -> bool:
    """Return *True* when the API response contains usable game data.

    The MLB Stats API returns a JSON object with a ``"message"`` key when
    something goes wrong server-side (sort-order violations, unknown games,
    etc.).  These responses must be skipped rather than parsed.
    """
    if not json_data.keys():
        return False

    if "message" in json_data and (
        json_data["message"] == "Comparison method violates its general contract!"
        or json_data.get("messageNumber") in [1, 13]
    ):
        return False

    return True
