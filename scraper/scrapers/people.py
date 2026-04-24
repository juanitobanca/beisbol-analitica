"""Scraper for MLB Stats API people (players/officials) data."""

import logging
from typing import Any

import constants as c
from core.config import settings
from constants.table_names import STG_PLAYERS
from core.dataset import Dataset, create_dataset, json_is_valid
from core.endpoints import people_batch_url
from core.http_client import http_client

from .base import BaseScraper

logger = logging.getLogger(__name__)


class People(BaseScraper):
    """Fetches and parses player biographical data in batches."""

    def __init__(self) -> None:
        self.people: Dataset = {}
        super().__init__()

    def _set_people(self, person: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract fields from an individual person dict."""
        for field in fields:
            try:
                if flag == c.PEOPLE_PRIMARY_POSITION_FLAG:
                    value = person[flag].get(field) if flag in person else None
                elif flag in (c.PEOPLE_BAT_SIDE_FLAG, c.PEOPLE_PITCH_HAND_FLAG):
                    value = person[flag].get("code") if flag in person else None
                else:
                    value = person.get(field)
            except KeyError:
                value = None

            dataset[field].append(value)

    def _init_datasets(self) -> None:
        self.people = self._register(STG_PLAYERS, create_dataset(
            c.PEOPLE_PRIMARY_POSITION + c.PEOPLE_BAT_SIDE + c.PEOPLE_PITCH_HAND,
            c.PEOPLE_META,
        ))

    def set_data(self, people_ids: set | list, **kwargs: Any) -> Dataset:
        """Fetch and parse people data in batches."""
        self._init_datasets()

        valid_ids = [i for i in people_ids if i]
        id_list = list(valid_ids)

        for start in range(0, len(id_list), settings.people_batch_size):
            batch = id_list[start : start + settings.people_batch_size]
            url = people_batch_url([int(i) for i in batch])
            json_data = http_client.get_json(url)

            if not json_is_valid(json_data):
                continue

            for person in json_data["people"]:
                self._set_people(person, c.PEOPLE_META_FLAG, c.PEOPLE_META, self.people)
                self._set_people(person, c.PEOPLE_PRIMARY_POSITION_FLAG, c.PEOPLE_PRIMARY_POSITION, self.people)
                self._set_people(person, c.PEOPLE_BAT_SIDE_FLAG, c.PEOPLE_BAT_SIDE, self.people)
                self._set_people(person, c.PEOPLE_PITCH_HAND_FLAG, c.PEOPLE_PITCH_HAND, self.people)

        return self.people
