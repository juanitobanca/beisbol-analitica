"""Scraper for MLB Stats API people (players/officials) data."""

import logging
from typing import Any

import const as c
from base_scraper import BaseScraper, Dataset
from config import settings

logger = logging.getLogger(__name__)


class People(BaseScraper):
    """Fetches and parses player biographical data in batches."""

    def __init__(self) -> None:
        self.game_pk: int | None = None
        self.people: Dataset = {}
        super().__init__()

    def _set_people(self, person: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract fields from an individual person dict."""
        for field in fields:
            try:
                if flag == c.PEOPLE_PRIMARY_POSITION_FLAG:
                    value = c.default_missing_value(person[flag], field, None)
                elif flag in (c.PEOPLE_BAT_SIDE_FLAG, c.PEOPLE_PITCH_HAND_FLAG):
                    if flag in person:
                        value = c.default_missing_value(person[flag], "code", None)
                    else:
                        value = None
                else:
                    value = c.default_missing_value(person, field, None)
            except KeyError:
                value = None

            dataset[field].append(value)

    def _init_datasets(self) -> None:
        self.people = c.create_dataset(
            c.PEOPLE_PRIMARY_POSITION + c.PEOPLE_BAT_SIDE + c.PEOPLE_PITCH_HAND,
            c.PEOPLE_META,
        )

    def set_data(self, people_ids: set | list, **kwargs: Any) -> Dataset:
        """Fetch and parse people data in batches."""
        self._init_datasets()

        valid_ids = [i for i in people_ids if i]
        id_list = list(valid_ids)

        for start in range(0, len(id_list), settings.people_batch_size):
            batch = id_list[start : start + settings.people_batch_size]
            parsing_arg = ",".join(str(int(i)) for i in batch)

            json_data = c.parse_json(parsing_arg, c.ENDPOINT_PEOPLE_BATCH)

            if not c.json_is_valid(json_data):
                continue

            for person in json_data["people"]:
                self._set_people(person, c.PEOPLE_META_FLAG, c.PEOPLE_META, self.people)
                self._set_people(person, c.PEOPLE_PRIMARY_POSITION_FLAG, c.PEOPLE_PRIMARY_POSITION, self.people)
                self._set_people(person, c.PEOPLE_BAT_SIDE_FLAG, c.PEOPLE_BAT_SIDE, self.people)
                self._set_people(person, c.PEOPLE_PITCH_HAND_FLAG, c.PEOPLE_PITCH_HAND, self.people)

        return self.people
