"""Scraper for MLB Stats API play-by-play data."""

import logging
from typing import Any

import const as c
from base_scraper import BaseScraper, Dataset
from extractor import extract_fields, nav, nav_id, nav_code, nav_description

logger = logging.getLogger(__name__)


class PlayByPlay(BaseScraper):
    """Fetches and parses play-by-play data for a list of game PKs."""

    def __init__(self) -> None:
        self.atbat: Dataset = {}
        self.runner: Dataset = {}
        self.credit: Dataset = {}
        self.pitch: Dataset = {}
        self.action: Dataset = {}
        self.pickoff: Dataset = {}
        super().__init__()

    def _set_about_result_count(self, play: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        extract_fields(play.get(flag), fields, dataset, nav)

    def _set_matchup(self, play: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract matchup data using flag-specific sub-key navigation."""
        matchup_sub = play.get("matchup", {}).get(flag)

        def resolver(node: dict | None, field: str) -> Any:
            if field.endswith("Code"):
                return nav_code(node)
            if field.endswith("Description"):
                return nav_description(node)
            if field.endswith("Id"):
                return nav_id(node)
            return nav(node, field)

        extract_fields(matchup_sub, fields, dataset, resolver)

    def _set_runner(self, runner: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract runner data with special handling for runnerId and responsiblePitcherId."""
        def resolver(node: dict | None, field: str) -> Any:
            if field == "runnerId":
                return nav_id(runner.get("details", {}).get("runner"))
            if field == "responsiblePitcherId":
                return nav_id(runner.get("details", {}).get("responsiblePitcher"))
            if field == "endBase":
                return nav(runner.get(flag), "end")
            if field == "startBase":
                return nav(runner.get(flag), "start")
            return nav(runner.get(flag), field)

        extract_fields(runner.get(flag), fields, dataset, resolver)

    def _set_credit(self, credit_node: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        def resolver(node: dict | None, field: str) -> Any:
            if flag == c.PLAY_CREDIT_CREDIT_FLAG:
                return nav(credit_node, field)
            if flag == c.PLAY_CREDIT_PLAYER_FLAG:
                return nav_id(credit_node.get(flag))
            return nav(credit_node.get(flag), field)

        extract_fields(credit_node, fields, dataset, resolver)

    def _set_pitch(self, pitch: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        """Extract pitch event data with flag-specific JSON navigation."""
        def resolver(node: dict | None, field: str) -> Any:
            if flag == c.PITCH_META2_FLAG:
                return nav(pitch, field)

            if flag == c.PITCH_DETAILS_FLAG:
                details = pitch.get("details", {})
                if field == "callCode":
                    return nav_code(details.get("call"))
                if field == "callDescription":
                    return nav_description(details.get("call"))
                if field == "typeCode":
                    return nav_code(details.get("type"))
                if field == "typeDescription":
                    return nav_description(details.get("type"))
                return nav(details, field)

            if flag == c.PITCH_COUNT_FLAG:
                return nav(pitch.get("count"), field)

            if flag == c.PITCH_DATA_FLAG:
                return nav(pitch.get("pitchData"), field)

            if flag in (c.PITCH_DATA_COORD_FLAG, c.PITCH_DATA_BREAKS_FLAG):
                return nav(pitch.get("pitchData", {}).get(flag), field)

            if flag == c.PITCH_HIT_DATA_FLAG:
                return nav(pitch.get("hitData"), field)

            if flag == c.PITCH_HIT_DATA_COORD_FLAG:
                hit = pitch.get("hitData")
                return nav(hit.get("coordinates") if hit else None, field)

            return nav(pitch.get(flag), field)

        extract_fields(None, fields, dataset, resolver)

    def _set_action(self, event: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        def resolver(node: dict | None, field: str) -> Any:
            if flag == c.ACTION_META2_FLAG:
                return nav(event, field)
            if flag == c.ACTION_PLAYER_FLAG:
                return nav_id(event.get(flag))
            if flag == c.ACTION_POSITION_FLAG:
                return nav(event.get(flag), field) if "position" in event else None
            return nav(event.get(flag), field)

        extract_fields(None, fields, dataset, resolver)

    def _set_pickoff(self, event: dict, flag: str, fields: list[str], dataset: Dataset) -> None:
        def resolver(node: dict | None, field: str) -> Any:
            if flag == c.PICKOFF_META2_FLAG:
                return nav(event, field)
            return nav(event.get(flag), field)

        extract_fields(None, fields, dataset, resolver)

    def _init_datasets(self) -> None:
        self.atbat = c.create_dataset(
            c.PLAY_ABOUT + c.PLAY_RESULT + c.PLAY_COUNT
            + c.PLAY_MATCHUP_BATSIDE + c.PLAY_MATCHUP_PITCHHAND
            + c.PLAY_MATCHUP_PITCHER + c.PLAY_MATCHUP_BATTER + c.PLAY_MATCHUP_SPLITS,
            c.PLAY_ATBAT_META,
        )

        self.pitch = c.create_dataset(
            c.PITCH_DETAILS + c.PITCH_COUNT + c.PITCH_DATA
            + c.PITCH_DATA_COORD + c.PITCH_DATA_BREAKS
            + c.PITCH_HIT_DATA + c.PITCH_HIT_DATA_COORD,
            c.PITCH_META + c.PITCH_META2,
        )

        self.action = c.create_dataset(
            c.ACTION_DETAILS + c.ACTION_COUNT + c.ACTION_PLAYER + c.ACTION_POSITION,
            c.ACTION_META + c.ACTION_META2,
        )

        self.pickoff = c.create_dataset(
            c.PICKOFF_DETAILS + c.PICKOFF_COUNT,
            c.PICKOFF_META + c.PICKOFF_META2,
        )

        self.runner = c.create_dataset(
            c.PLAY_RUNNER_MOVEMENT + c.PLAY_RUNNER_DETAILS,
            c.PLAY_RUNNER_META,
        )

        self.credit = c.create_dataset(
            c.PLAY_CREDIT_CREDIT + c.PLAY_CREDIT_PLAYER + c.PLAY_CREDIT_POSITION,
            c.PLAY_CREDIT_META,
        )

    def set_data(self, game_pks: list[int], **kwargs: Any) -> None:
        """Fetch and parse play-by-play data for each game PK."""
        self._init_datasets()

        for game_pk in game_pks:
            json_data = c.parse_json(game_pk, c.ENDPOINT_PLAY_BY_PLAY)

            if not c.json_is_valid(json_data):
                continue

            for play in json_data["allPlays"]:
                self.atbat["gamePk"].append(game_pk)
                self._set_about_result_count(play, c.PLAY_ABOUT_FLAG, c.PLAY_ABOUT, self.atbat)
                self._set_about_result_count(play, c.PLAY_RESULT_FLAG, c.PLAY_RESULT, self.atbat)
                self._set_about_result_count(play, c.PLAY_COUNT_FLAG, c.PLAY_COUNT, self.atbat)

                self._set_matchup(play, c.PLAY_MATCHUP_BATSIDE_FLAG, c.PLAY_MATCHUP_BATSIDE, self.atbat)
                self._set_matchup(play, c.PLAY_MATCHUP_PITCHHAND_FLAG, c.PLAY_MATCHUP_PITCHHAND, self.atbat)
                self._set_matchup(play, c.PLAY_MATCHUP_BATTER_FLAG, c.PLAY_MATCHUP_BATTER, self.atbat)
                self._set_matchup(play, c.PLAY_MATCHUP_PITCHER_FLAG, c.PLAY_MATCHUP_PITCHER, self.atbat)
                self._set_matchup(play, c.PLAY_MATCHUP_SPLITS_FLAG, c.PLAY_MATCHUP_SPLITS, self.atbat)

                for event in play["playEvents"]:
                    event_type = event["type"]

                    if event_type == "pitch":
                        self.pitch["gamePk"].append(game_pk)
                        self.pitch["atBatIndex"].append(play["atBatIndex"])
                        self._set_pitch(event, c.PITCH_META2_FLAG, c.PITCH_META2, self.pitch)
                        self._set_pitch(event, c.PITCH_DETAILS_FLAG, c.PITCH_DETAILS, self.pitch)
                        self._set_pitch(event, c.PITCH_COUNT_FLAG, c.PITCH_COUNT, self.pitch)
                        self._set_pitch(event, c.PITCH_DATA_FLAG, c.PITCH_DATA, self.pitch)
                        self._set_pitch(event, c.PITCH_DATA_COORD_FLAG, c.PITCH_DATA_COORD, self.pitch)
                        self._set_pitch(event, c.PITCH_DATA_BREAKS_FLAG, c.PITCH_DATA_BREAKS, self.pitch)
                        self._set_pitch(event, c.PITCH_HIT_DATA_FLAG, c.PITCH_HIT_DATA, self.pitch)
                        self._set_pitch(event, c.PITCH_HIT_DATA_COORD_FLAG, c.PITCH_HIT_DATA_COORD, self.pitch)

                    elif event_type == "action":
                        self.action["gamePk"].append(game_pk)
                        self.action["atBatIndex"].append(play["atBatIndex"])
                        self._set_action(event, c.ACTION_META2_FLAG, c.ACTION_META2, self.action)
                        self._set_action(event, c.ACTION_DETAILS_FLAG, c.ACTION_DETAILS, self.action)
                        self._set_action(event, c.ACTION_COUNT_FLAG, c.ACTION_COUNT, self.action)
                        self._set_action(event, c.ACTION_PLAYER_FLAG, c.ACTION_PLAYER, self.action)
                        self._set_action(event, c.ACTION_POSITION_FLAG, c.ACTION_POSITION, self.action)

                    elif event_type == "pickoff":
                        self.pickoff["gamePk"].append(game_pk)
                        self.pickoff["atBatIndex"].append(play["atBatIndex"])
                        self._set_pickoff(event, c.PICKOFF_META2_FLAG, c.PICKOFF_META2, self.pickoff)
                        self._set_pickoff(event, c.PICKOFF_DETAILS_FLAG, c.PICKOFF_DETAILS, self.pickoff)
                        self._set_pickoff(event, c.PICKOFF_COUNT_FLAG, c.PICKOFF_COUNT, self.pickoff)

                for runner in play["runners"]:
                    self.runner["gamePk"].append(game_pk)
                    self.runner["atBatIndex"].append(play["atBatIndex"])
                    self._set_runner(runner, c.PLAY_RUNNER_MOVEMENT_FLAG, c.PLAY_RUNNER_MOVEMENT, self.runner)
                    self._set_runner(runner, c.PLAY_RUNNER_DETAILS_FLAG, c.PLAY_RUNNER_DETAILS, self.runner)

                    for credit in runner.get("credits", []):
                        self.credit["gamePk"].append(game_pk)
                        self.credit["atBatIndex"].append(play["atBatIndex"])
                        self._set_credit(credit, c.PLAY_CREDIT_CREDIT_FLAG, c.PLAY_CREDIT_CREDIT, self.credit)
                        self._set_credit(credit, c.PLAY_CREDIT_PLAYER_FLAG, c.PLAY_CREDIT_PLAYER, self.credit)
                        self._set_credit(credit, c.PLAY_CREDIT_POSITION_FLAG, c.PLAY_CREDIT_POSITION, self.credit)
