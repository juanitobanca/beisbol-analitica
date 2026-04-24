"""Configuration loader using pydantic-settings."""

from pathlib import Path

import yaml
from pydantic_settings import BaseSettings


_CONFIG_PATH = Path(__file__).parent.parent / "config.yaml"


def _load_yaml() -> dict:
    with open(_CONFIG_PATH) as f:
        return yaml.safe_load(f)


class Settings(BaseSettings):
    base_url: str = "http://statsapi.mlb.com/api/v1"
    retry_delay_seconds: int = 20
    people_batch_size: int = 100
    default_batch_size: int = 500
    default_workers: int = 10
    default_db_connection: str = "sqlite:///baseball.db"

    model_config = {"env_prefix": "SCRAPPER_"}


_yaml_values = _load_yaml() if _CONFIG_PATH.exists() else {}
settings = Settings(**_yaml_values)
