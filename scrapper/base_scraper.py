"""Abstract base class for all MLB Stats API scrapers."""

from abc import ABC, abstractmethod
from typing import Any


Dataset = dict[str, list[Any]]


class BaseScraper(ABC):
    """Common interface for scrapers that fetch and parse MLB Stats API data."""

    def __init__(self) -> None:
        self.datasets: dict[str, Dataset] = {}
        self._init_datasets()

    @abstractmethod
    def _init_datasets(self) -> None:
        """Initialize empty dataset dictionaries for accumulating parsed data."""
        ...

    @abstractmethod
    def set_data(self, ids: list, **kwargs: Any) -> None:
        """Fetch and parse data for the given identifiers."""
        ...
