"""Scraper for MLB Stats API boxscore data."""

import logging
from typing import Any

import constants as c
from constants.table_names import (
    STG_BOX_INFO, STG_BOX_OFFICIALS, STG_BOX_TEAM, STG_BOX_TEAM_BATTING,
    STG_BOX_TEAM_PITCHING, STG_BOX_TEAM_FIELDING, STG_BOX_TEAM_BATTING_ORDER,
    STG_BOX_PLAYER_BATTING, STG_BOX_PLAYER_PITCHING, STG_BOX_PLAYER_FIELDING,
    STG_BOX_PLAYER_GAME_INFO, STG_BOX_PLAYER_GAME_POSITIONS,
)
from core.dataset import Dataset, create_dataset, json_is_valid
from core.endpoints import game_url
from core.extractor import extract_fields, nav, nav_id, nav_name, nav_link
from core.http_client import http_client

from .base import BaseScraper

logger = logging.getLogger(__name__)


class Boxscore(BaseScraper):
    """Fetches and parses boxscore data for a list of game PKs."""

    def __init__(self) -> None:
        self.game_pk: int | None = None
        self.player_batting: Dataset = {}
        self.player_pitching: Dataset = {}
        self.player_fielding: Dataset = {}
        self.team_batting: Dataset = {}
        self.team_pitching: Dataset = {}
        self.team_fielding: Dataset = {}
        self.team_batting_order: Dataset = {}
        self.team: Dataset = {}
        self.player_game_positions: Dataset = {}
        self.player_game_info: Dataset = {}
        self.info: Dataset = {}
        self.official_types: Dataset = {}
        super().__init__()

    def _set_metadata(self, json_data: dict, dataset: Dataset, team_side: str, player_key: str | None) -> None:
        dataset["gamePk"].append(self.game_pk)
        dataset["teamId"].append(json_data["teams"][team_side]["team"]["id"])
        dataset["teamType"].append(team_side)
        if player_key:
            dataset["playerId"].append(json_data["teams"][team_side]["players"][player_key]["person"]["id"])

    def _set_official_types(self, official: dict, dataset: Dataset) -> None:
        extract_fields(official, ["officialId"], dataset, lambda n, f: nav_id(n.get("official")))
        extract_fields(official, ["position"], dataset, lambda n, f: nav(n, "officialType"))

    def _set_info(self, json_data: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract game info from the label/value list structure."""
        label_map: dict[str, Any] = {"weather": None, "wind": None, "attendance": None}

        if flag in json_data:
            for item in json_data[flag]:
                label = item.get("label", "").lower()
                if label == "att":
                    label_map["attendance"] = item.get("value")
                elif label in label_map:
                    label_map[label] = item.get("value")

        for field in fields:
            dataset[field].append(label_map.get(field))

    def _set_batting_order(self, json_data: dict, team_side: str, dataset: Dataset) -> None:
        try:
            players = json_data["teams"][team_side]["players"]
            for pid_key, player in players.items():
                self._set_metadata(json_data, dataset, team_side, None)
                dataset["playerId"].append(int(pid_key.replace("ID", "")))
                dataset["battingOrder"].append(player.get("battingOrder"))
        except Exception as e:
            logger.error("set_batting_order error: %s", e)

    def _set_team(self, json_data: dict, team_side: str, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract team-level data using flag-specific navigation."""
        team_node = json_data["teams"][team_side]

        if flag == c.BOX_TEAM_META2_FLAG:
            extract_fields(team_node.get("team"), fields, dataset, nav)
        else:
            sub_node = team_node.get("team", {}).get(flag)

            def resolver_sub(node: dict | None, field: str) -> Any:
                if "Id" in field:
                    return nav_id(sub_node)
                if "Name" in field:
                    return nav_name(sub_node)
                if "Link" in field:
                    return nav_link(sub_node)
                return nav(team_node.get("teamStats", {}).get(flag), field)

            extract_fields(sub_node, fields, dataset, resolver_sub)

    def _set_player(self, json_data: dict, team_side: str, player_key: str, flag: str, fields: list[str], dataset: Dataset) -> None:
        node = json_data["teams"][team_side]["players"][player_key].get(flag)
        extract_fields(node, fields, dataset, nav)

    def _set_stats(
        self, json_data: dict, team_side: str, player_key: str | None, flag: str, fields: list[str], dataset: Dataset
    ) -> None:
        try:
            if player_key:
                node = json_data["teams"][team_side]["players"][player_key]["stats"].get(flag)
            else:
                node = json_data["teams"][team_side]["teamStats"].get(flag)
        except KeyError:
            node = None
        extract_fields(node, fields, dataset, nav)

    def _init_datasets(self) -> None:
        self.info = self._register(STG_BOX_INFO, create_dataset(c.BOX_INFO_DETAILS, c.BOX_INFO_META))
        self.official_types = self._register(STG_BOX_OFFICIALS, create_dataset(c.BOX_OFFICIALS_DETAILS, c.BOX_OFFICIALS_META))

        self.team = self._register(STG_BOX_TEAM, create_dataset(
            c.BOX_TEAM_META2 + c.BOX_TEAM_LEAGUE + c.BOX_TEAM_VENUE + c.BOX_TEAM_DIVISION,
            c.BOX_TEAM_META,
        ))

        self.team_batting = self._register(STG_BOX_TEAM_BATTING, create_dataset(c.BOX_TEAM_BATTING_STATS, c.BOX_TEAM_META))
        self.team_pitching = self._register(STG_BOX_TEAM_PITCHING, create_dataset(c.BOX_TEAM_PITCHING_STATS, c.BOX_TEAM_META))
        self.team_fielding = self._register(STG_BOX_TEAM_FIELDING, create_dataset(c.BOX_TEAM_FIELDING_STATS, c.BOX_TEAM_META))

        self.team_batting_order = self._register(STG_BOX_TEAM_BATTING_ORDER, create_dataset(c.BOX_TEAM_BATTING_ORDER_FIELDS, c.BOX_TEAM_BATTING_ORDER_META))

        self.player_batting = self._register(STG_BOX_PLAYER_BATTING, create_dataset(c.BOX_PLAYER_BATTING_STATS, c.BOX_PLAYER_META))
        self.player_pitching = self._register(STG_BOX_PLAYER_PITCHING, create_dataset(c.BOX_PLAYER_PITCHING_STATS, c.BOX_PLAYER_META))
        self.player_fielding = self._register(STG_BOX_PLAYER_FIELDING, create_dataset(c.BOX_PLAYER_FIELDING_STATS, c.BOX_PLAYER_META))

        self.player_game_info = self._register(STG_BOX_PLAYER_GAME_INFO, create_dataset(
            c.BOX_PLAYER_GAME_STATUS + c.BOX_PLAYER_PERSON + c.BOX_PLAYER_POSITION,
            c.BOX_PLAYER_META,
        ))

        self.player_game_positions = self._register(STG_BOX_PLAYER_GAME_POSITIONS, create_dataset(c.BOX_PLAYER_ALL_POSITIONS, c.BOX_PLAYER_META))

    def set_data(self, game_pks: list[int], **kwargs: Any) -> None:
        """Fetch and parse boxscore data for each game PK."""
        self._init_datasets()

        for game_pk in game_pks:
            self.game_pk = game_pk
            json_data = http_client.get_json(game_url(game_pk, c.ENDPOINT_BOXSCORE))

            if not json_is_valid(json_data):
                logger.warning("Invalid JSON, skipping game %s.", game_pk)
                continue

            self.info["gamePk"].append(game_pk)
            self._set_info(json_data, c.BOX_INFO_FLAG, c.BOX_INFO_DETAILS, self.info)

            for official in json_data["officials"]:
                self.official_types["gamePk"].append(game_pk)
                self._set_official_types(official, self.official_types)

            for team_side in json_data["teams"]:
                self._set_metadata(json_data, self.team, team_side, None)
                self._set_team(json_data, team_side, c.BOX_TEAM_META2_FLAG, c.BOX_TEAM_META2, self.team)
                self._set_team(json_data, team_side, c.BOX_TEAM_LEAGUE_FLAG, c.BOX_TEAM_LEAGUE, self.team)
                self._set_team(json_data, team_side, c.BOX_TEAM_VENUE_FLAG, c.BOX_TEAM_VENUE, self.team)
                self._set_team(json_data, team_side, c.BOX_TEAM_DIVISION_FLAG, c.BOX_TEAM_DIVISION, self.team)

                self._set_metadata(json_data, self.team_batting, team_side, None)
                self._set_stats(json_data, team_side, None, c.BOX_TEAM_BATTING_FLAG, c.BOX_TEAM_BATTING_STATS, self.team_batting)

                self._set_metadata(json_data, self.team_pitching, team_side, None)
                self._set_stats(json_data, team_side, None, c.BOX_TEAM_PITCHING_FLAG, c.BOX_TEAM_PITCHING_STATS, self.team_pitching)

                self._set_metadata(json_data, self.team_fielding, team_side, None)
                self._set_stats(json_data, team_side, None, c.BOX_TEAM_FIELDING_FLAG, c.BOX_TEAM_FIELDING_STATS, self.team_fielding)

                self._set_batting_order(json_data, team_side, self.team_batting_order)

                for player_key in json_data["teams"][team_side]["players"]:
                    self._set_metadata(json_data, self.player_batting, team_side, player_key)
                    self._set_metadata(json_data, self.player_pitching, team_side, player_key)
                    self._set_metadata(json_data, self.player_fielding, team_side, player_key)
                    self._set_metadata(json_data, self.player_game_info, team_side, player_key)

                    self._set_stats(json_data, team_side, player_key, c.BOX_PLAYER_BATTING_FLAG, c.BOX_PLAYER_BATTING_STATS, self.player_batting)
                    self._set_stats(json_data, team_side, player_key, c.BOX_PLAYER_PITCHING_FLAG, c.BOX_PLAYER_PITCHING_STATS, self.player_pitching)
                    self._set_stats(json_data, team_side, player_key, c.BOX_PLAYER_FIELDING_FLAG, c.BOX_PLAYER_FIELDING_STATS, self.player_fielding)

                    self._set_player(json_data, team_side, player_key, c.BOX_PLAYER_GAME_STATUS_FLAG, c.BOX_PLAYER_GAME_STATUS, self.player_game_info)
                    self._set_player(json_data, team_side, player_key, c.BOX_PLAYER_PERSON_FLAG, c.BOX_PLAYER_PERSON, self.player_game_info)
                    self._set_player(json_data, team_side, player_key, c.BOX_PLAYER_POSITION_FLAG, c.BOX_PLAYER_POSITION, self.player_game_info)

                    player_node = json_data["teams"][team_side]["players"][player_key]
                    for position in player_node.get("allPositions", []):
                        self._set_metadata(json_data, self.player_game_positions, team_side, player_key)
                        extract_fields(position, c.BOX_PLAYER_ALL_POSITIONS, self.player_game_positions, nav)
