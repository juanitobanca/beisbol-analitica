"""HTTP client for the MLB Stats API with retry logic."""

import logging
import time

import requests

from .config import settings

logger = logging.getLogger(__name__)


class MLBHttpClient:
    """Thin wrapper around requests.Session with bounded retry logic."""

    def __init__(self) -> None:
        self._session = requests.Session()

    def get_json(self, url: str, max_retries: int = 10) -> dict:
        """Fetch JSON from *url*, retrying up to *max_retries* times on failure.

        Raises:
            RuntimeError: if all retry attempts are exhausted.
        """
        last_exc: Exception | None = None

        for attempt in range(1, max_retries + 1):
            try:
                response = self._session.get(url, timeout=30)
                response.raise_for_status()
                return response.json()
            except Exception as exc:
                last_exc = exc
                logger.warning(
                    "Attempt %d/%d failed for %s: %s",
                    attempt,
                    max_retries,
                    url,
                    exc,
                )
                if attempt < max_retries:
                    time.sleep(settings.retry_delay_seconds)

        raise RuntimeError(
            f"All {max_retries} attempts exhausted for {url}"
        ) from last_exc


# Module-level singleton — scrapers import this directly.
http_client = MLBHttpClient()
