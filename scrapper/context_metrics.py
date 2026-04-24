"""Scraper for MLB Stats API context metrics (game-level metadata)."""

import logging
from typing import Any

import const as c
from base_scraper import BaseScraper, Dataset
from extractor import extract_fields, nav

logger = logging.getLogger(__name__)


class ContextMetrics(BaseScraper):
    """Fetches and parses context metrics for a list of game PKs."""

    def __init__(self) -> None:
        self.context_metrics: Dataset = {}
        super().__init__()

    def _set_context_metrics(self, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract context metrics using flag-specific JSON navigation."""
        game = self.json.get("game", {})

        def resolver_game(node: dict | None, field: str) -> Any:
            return nav(game, field)

        def resolver_status(node: dict | None, field: str) -> Any:
            return nav(game.get("status"), field)

        def resolver_venue(node: dict | None, field: str) -> Any:
            sub_key = field[5].lower() + field[6:]
            return nav(game.get("venue"), sub_key)

        def resolver_team_side(node: dict | None, field: str) -> Any:
            sub_key = field[4].lower() + field[5:]
            teams = game.get("teams", {})
            side = teams.get(flag, {})
            if sub_key in ("wins", "losses", "pct"):
                return nav(side.get("leagueRecord"), sub_key)
            if sub_key in ("id", "name"):
                return nav(side.get("team"), sub_key)
            return nav(side, sub_key)

        resolver_map = {
            c.CONTEXT_GAME_FLAG: resolver_game,
            c.CONTEXT_GAME_STATUS_FLAG: resolver_status,
            c.CONTEXT_GAME_VENUE_FLAG: resolver_venue,
            c.CONTEXT_GAME_AWAY_FLAG: resolver_team_side,
            c.CONTEXT_GAME_HOME_FLAG: resolver_team_side,
        }

        resolver = resolver_map.get(flag, lambda n, f: nav(self.json, f))
        extract_fields(None, fields, dataset, resolver)

    def _init_datasets(self) -> None:
        self.context_metrics = c.create_dataset(
            c.CONTEXT_GAME + c.CONTEXT_GAME_STATUS + c.CONTEXT_GAME_AWAY + c.CONTEXT_GAME_HOME + c.CONTEXT_GAME_VENUE,
            None,
        )

    def set_data(
        self,
        game_pks: list[int],
        major_league: str | None = None,
        major_league_id: int | None = None,
        **kwargs: Any,
    ) -> Dataset:
        """Fetch and parse context metrics for each game PK."""
        self._init_datasets()

        for game_pk in game_pks:
            self.json = c.parse_json(game_pk, c.ENDPOINT_CONTEXT_METRICS)

            if not c.json_is_valid(self.json):
                continue

            self._set_context_metrics(c.CONTEXT_GAME_FLAG, c.CONTEXT_GAME, self.context_metrics)
            self._set_context_metrics(c.CONTEXT_GAME_STATUS_FLAG, c.CONTEXT_GAME_STATUS, self.context_metrics)
            self._set_context_metrics(c.CONTEXT_GAME_AWAY_FLAG, c.CONTEXT_GAME_AWAY, self.context_metrics)
            self._set_context_metrics(c.CONTEXT_GAME_HOME_FLAG, c.CONTEXT_GAME_HOME, self.context_metrics)
            self._set_context_metrics(c.CONTEXT_GAME_VENUE_FLAG, c.CONTEXT_GAME_VENUE, self.context_metrics)

        n = len(self.context_metrics["gamePk"])
        self.context_metrics["majorLeague"] = [major_league] * n
        self.context_metrics["majorLeagueId"] = [major_league_id] * n

        return self.context_metrics
