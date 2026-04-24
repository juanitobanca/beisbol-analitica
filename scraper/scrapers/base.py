"""Abstract base class for all MLB Stats API scrapers."""

from abc import ABC, abstractmethod
from typing import Any

from core.dataset import Dataset


class BaseScraper(ABC):
    """Common interface for scrapers that fetch and parse MLB Stats API data."""

    def __init__(self) -> None:
        self.datasets: dict[str, Dataset] = {}
        self._init_datasets()

    def _register(self, table_name: str, dataset: Dataset) -> Dataset:
        """Register a dataset under its staging table name and return it."""
        self.datasets[table_name] = dataset
        return dataset

    @abstractmethod
    def _init_datasets(self) -> None:
        """Initialize empty dataset dictionaries for accumulating parsed data."""
        ...

    @abstractmethod
    def set_data(self, ids: list, **kwargs: Any) -> None:
        """Fetch and parse data for the given identifiers."""
        ...
