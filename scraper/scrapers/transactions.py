"""Scraper for MLB Stats API transaction data."""

import logging
from typing import Any

import constants as c
from constants.table_names import STG_TRANSACTIONS
from core.dataset import Dataset, create_dataset, json_is_valid
from core.endpoints import transactions_url
from core.http_client import http_client

from .base import BaseScraper

logger = logging.getLogger(__name__)


class Transactions(BaseScraper):
    """Fetches and parses transaction data for given teams and date range."""

    def __init__(self) -> None:
        self.transactions: Dataset = {}
        super().__init__()

    def _append_transaction(self, transaction: dict, team_id: int, dataset: Dataset) -> None:
        """Write exactly one row across all dataset columns."""
        dataset["id"].append(transaction.get("id"))
        dataset["transactionDate"].append(transaction.get("date"))
        dataset["effectiveDate"].append(transaction.get("effectiveDate"))
        dataset["resolutionDate"].append(transaction.get("resolutionDate"))
        dataset["typeCode"].append(transaction.get("typeCode"))
        dataset["typeDesc"].append(transaction.get("typeDesc"))
        dataset["description"].append(transaction.get("description"))

        person = transaction.get(c.TRANSACTIONS_PERSON_FLAG)
        to_team = transaction.get(c.TRANSACTIONS_TO_TEAM_FLAG)

        dataset["personId"].append(person.get("id") if person else None)
        dataset["toTeamId"].append(to_team.get("id") if to_team else None)
        dataset["teamId"].append(team_id)

    def _init_datasets(self) -> None:
        self.transactions = self._register(STG_TRANSACTIONS, create_dataset(
            c.TRANSACTIONS_PERSON_ID + c.TRANSACTIONS_TO_TEAM_ID + c.TRANSACTIONS_TEAM_ID,
            c.TRANSACTIONS_META,
        ))

    def set_data(
        self,
        team_ids: set | list,
        start_date: str | None = None,
        end_date: str | None = None,
        **kwargs: Any,
    ) -> Dataset:
        """Fetch and parse transaction data for each team in the date range."""
        self._init_datasets()

        for team_id in team_ids:
            if not team_id:
                continue

            url = transactions_url(int(team_id), start_date, end_date)
            json_data = http_client.get_json(url)

            if not json_is_valid(json_data):
                continue

            for transaction in json_data["transactions"]:
                self._append_transaction(transaction, team_id, self.transactions)

        return self.transactions
