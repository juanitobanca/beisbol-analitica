"""Database writer: converts datasets to DataFrames and inserts them with retry logic."""

import logging
import time

import pandas as pd
from sqlalchemy import Engine

from core.config import settings
from core.dataset import Dataset

logger = logging.getLogger(__name__)


def to_dataframe(data: Dataset) -> pd.DataFrame:
    """Convert a dataset dict to a pandas DataFrame."""
    return pd.DataFrame.from_dict(data)


def insert(
    dataframe: pd.DataFrame,
    engine: Engine,
    table_name: str,
    max_retries: int = 1,
) -> None:
    """Insert *dataframe* into *table_name*, retrying on failure.

    Args:
        dataframe:   Data to insert.
        engine:      SQLAlchemy engine.
        table_name:  Target staging table name.
        max_retries: Maximum number of attempts before raising.

    Raises:
        RuntimeError: if all retry attempts are exhausted.
    """
    logger.info("%s: Inserting %d records.", table_name, len(dataframe))

    last_exc: Exception | None = None

    for attempt in range(1, max_retries + 1):
        try:
            dataframe.to_sql(name=table_name, con=engine, if_exists="append", index=False)
            return
        except Exception as exc:
            last_exc = exc
            logger.error(
                "%s: Insert attempt %d/%d failed: %s",
                table_name,
                attempt,
                max_retries,
                exc,
            )
            if attempt < max_retries:
                time.sleep(settings.retry_delay_seconds)

    raise RuntimeError(
        f"{table_name}: all {max_retries} insert attempts exhausted"
    ) from last_exc


def insert_dataset(
    data: Dataset,
    engine: Engine,
    table_name: str,
    max_retries: int = 1,
) -> None:
    """Convenience wrapper: convert *data* to DataFrame and insert it."""
    insert(to_dataframe(data), engine, table_name, max_retries)
