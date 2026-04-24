"""Constants and shared utilities for the MLB Stats API scrapper."""

import logging
import time
from typing import Any

import requests as r

from config import settings

logger = logging.getLogger(__name__)

Dataset = dict[str, list[Any]]

_session = r.Session()


def create_dataset(fields: list[str], meta_fields: list[str] | None) -> Dataset:
    """Build an empty dataset dict with a list per field name."""
    dataset: Dataset = {}
    for field in fields:
        dataset[field] = []
    if meta_fields:
        for meta_field in meta_fields:
            dataset[meta_field] = []
    return dataset


def default_missing_value(d: dict | None, k: str, v: Any = None) -> Any:
    """Safely get a key from a dict, returning None if absent."""
    if not d:
        return None
    return d.get(k)


def parse_json(parsing_arg: str | int, file: str) -> dict:
    """Fetch JSON from the MLB Stats API for the given endpoint."""
    base = settings.base_url

    if file == ENDPOINT_PEOPLE_BATCH:
        url = f"{base}/people?personIds={parsing_arg}"
        logger.info("Players (batch): %s. Parsing %s.", parsing_arg, file)

    elif file == ENDPOINT_PEOPLE:
        url = f"{base}/people/{int(parsing_arg)}"
        logger.info("Player: %s. Parsing %s.", int(parsing_arg), file)

    elif file == ENDPOINT_TRANSACTIONS:
        url = f"{base}/transactions?{parsing_arg}"
        logger.info("Team: %s. Parsing %s.", parsing_arg, file)

    elif file == ENDPOINT_SCHEDULE:
        url = f"{base}/schedule?{parsing_arg}"
        logger.info("Schedule: %s. Parsing %s.", parsing_arg, file)

    else:
        url = f"{base}/game/{int(parsing_arg)}/{file}"
        logger.info("Game: %s. Parsing %s.", int(parsing_arg), file)

    while True:
        try:
            response = _session.get(url)
            return response.json()
        except Exception as e:
            logger.error("Error parsing game %s, file %s: %s", parsing_arg, file, e)
            time.sleep(settings.retry_delay_seconds)
            continue


def json_is_valid(json_data: dict) -> bool:
    """Check if the API response represents valid game data."""
    if not json_data.keys():
        return False

    if "message" in json_data and (
        json_data["message"] == "Comparison method violates its general contract!"
        or json_data.get("messageNumber") in [1, 13]
    ):
        return False

    return True


# ---------------------------------------------------------------------------
# Endpoint identifiers
# ---------------------------------------------------------------------------

ENDPOINT_PLAY_BY_PLAY = "playByPlay"
ENDPOINT_BOXSCORE = "boxscore"
ENDPOINT_PEOPLE = "people"
ENDPOINT_PEOPLE_BATCH = "people_batch"
ENDPOINT_CONTEXT_METRICS = "contextMetrics"
ENDPOINT_SCHEDULE = "schedule"
ENDPOINT_TRANSACTIONS = "transactions"

# ---------------------------------------------------------------------------
# Sport / League mappings
# ---------------------------------------------------------------------------

SPORT_ID: dict[str, int] = {
    "MLB": 1,
    "LMB": 11,
    "DSL": 16,
    "LIDOM": 17,
    "LMP": 17,
    "LBPRC": 17,
    "VSL": 17,
    "LVBP": 17,
    "SDC": 17,
    "WBCQ": 51,
    "WBC": 51,
}

LEAGUE_ID: dict[str, int] = {
    "MLB": 1,
    "LMB": 125,
    "DSL": 130,
    "LIDOM": 131,
    "LMP": 132,
    "LBPRC": 133,
    "VSL": 134,
    "LVBP": 135,
    "WBCQ": 159,
    "WBC": 160,
    "SDC": 162,
}

# ---------------------------------------------------------------------------
# Staging table names
# ---------------------------------------------------------------------------

STG_TRANSACTIONS = "stg_transactions"
STG_GAME_CONTEXT = "stg_game_context"

STG_BOX_TEAM_BATTING = "stg_box_team_batting"
STG_BOX_TEAM_PITCHING = "stg_box_team_pitching"
STG_BOX_TEAM_FIELDING = "stg_box_team_fielding"

STG_BOX_PLAYER_BATTING = "stg_box_player_batting"
STG_BOX_PLAYER_PITCHING = "stg_box_player_pitching"
STG_BOX_PLAYER_FIELDING = "stg_box_player_fielding"

STG_PLAYERS = "stg_players"
STG_OFFICIALS = "stg_officials"

STG_BOX_TEAM_BATTING_ORDER = "stg_box_team_batting_order"
STG_BOX_TEAM = "stg_box_team"
STG_BOX_PLAYER_GAME_POSITIONS = "stg_box_player_game_positions"
STG_BOX_PLAYER_GAME_INFO = "stg_box_player_game_info"
STG_BOX_INFO = "stg_box_info"
STG_BOX_OFFICIALS = "stg_box_officials"

STG_PLAY_ATBAT = "stg_play_atbat"
STG_PLAY_RUNNER = "stg_play_runner"
STG_PLAY_CREDIT = "stg_play_credit"
STG_PLAY_PITCH = "stg_play_pitch"
STG_PLAY_ACTION = "stg_play_action"
STG_PLAY_PICKOFF = "stg_play_pickoff"

# ---------------------------------------------------------------------------
# Context metrics field definitions
# ---------------------------------------------------------------------------

CONTEXT_GAME_FLAG = "game"
CONTEXT_GAME_STATUS_FLAG = "status"
CONTEXT_GAME_AWAY_FLAG = "away"
CONTEXT_GAME_HOME_FLAG = "home"
CONTEXT_GAME_VENUE_FLAG = "venue"
CONTEXT_GAME_META_FLAG = "meta"

CONTEXT_GAME: list[str] = [
    "gamePk", "gameType", "season", "gameDate", "isTie", "gameNumber", "publicFacing",
    "doubleHeader", "gamedayType", "tiebreaker", "calendarEventID", "seasonDisplay",
    "dayNight", "description", "scheduledInnings", "gamesInSeries", "seriesGameNumber",
    "seriesDescription", "recordSource", "ifNecessary", "ifNecessaryDescription", "gameId",
]
CONTEXT_GAME_STATUS: list[str] = [
    "abstractGameState", "codedGameState", "detailedState", "statusCode", "abstractGameCode",
]
CONTEXT_GAME_AWAY: list[str] = [
    "awayWins", "awayLosses", "awayPct", "awayScore", "awayId", "awayName", "awayIsWinner",
]
CONTEXT_GAME_HOME: list[str] = [
    "homeWins", "homeLosses", "homePct", "homeScore", "homeId", "homeName", "homeIsWinner",
]
CONTEXT_GAME_VENUE: list[str] = ["venueId", "venueName", "venueLink"]

# ---------------------------------------------------------------------------
# People field definitions
# ---------------------------------------------------------------------------

PEOPLE_META: list[str] = [
    "id", "fullName", "link", "firstName", "lastName", "birthDate", "currentAge",
    "birthCity", "birthStateProvince", "birthCountry", "height", "weight", "active",
    "useName", "middleName", "boxscoreName", "nameFirstLast", "nameSlug",
    "firstLastName", "lastFirstName", "lastInitName", "initLastName", "fullFMLName",
    "fullLFMName", "strikeZoneTop", "strikeZoneBottom",
]

PEOPLE_PRIMARY_POSITION: list[str] = ["abbreviation"]
PEOPLE_BAT_SIDE: list[str] = ["batSideCode"]
PEOPLE_PITCH_HAND: list[str] = ["pitchHandCode"]

PEOPLE_META_FLAG = "meta"
PEOPLE_PRIMARY_POSITION_FLAG = "primaryPosition"
PEOPLE_BAT_SIDE_FLAG = "batSide"
PEOPLE_PITCH_HAND_FLAG = "pitchHand"

# ---------------------------------------------------------------------------
# Transaction field definitions
# ---------------------------------------------------------------------------

TRANSACTIONS_META: list[str] = [
    "id", "transactionDate", "effectiveDate", "resolutionDate", "typeCode", "typeDesc", "description",
]
TRANSACTIONS_PERSON_ID: list[str] = ["personId"]
TRANSACTIONS_TO_TEAM_ID: list[str] = ["toTeamId"]
TRANSACTIONS_TEAM_ID: list[str] = ["teamId"]
TRANSACTIONS_META_FLAG = "meta"
TRANSACTIONS_PERSON_FLAG = "person"
TRANSACTIONS_TO_TEAM_FLAG = "toTeam"

# ---------------------------------------------------------------------------
# Play-by-play field definitions
# ---------------------------------------------------------------------------

PLAY_ATBAT_META: list[str] = ["gamePk"]

PLAY_ABOUT_FLAG = "about"
PLAY_RESULT_FLAG = "result"
PLAY_COUNT_FLAG = "count"

PLAY_ABOUT: list[str] = [
    "atBatIndex", "captivatingIndex", "endTime", "halfInning", "hasOut", "hasReview",
    "inning", "isComplete", "isScoringPlay", "startTime",
]
PLAY_RESULT: list[str] = ["awayScore", "description", "event", "eventType", "homeScore", "rbi", "type"]
PLAY_COUNT: list[str] = ["balls", "outs", "strikes"]

PLAY_MATCHUP_BATSIDE_FLAG = "batSide"
PLAY_MATCHUP_PITCHHAND_FLAG = "pitchHand"
PLAY_MATCHUP_BATTER_FLAG = "batter"
PLAY_MATCHUP_PITCHER_FLAG = "pitcher"
PLAY_MATCHUP_SPLITS_FLAG = "splits"

PLAY_MATCHUP_BATSIDE: list[str] = ["batterSideCode", "batterSideDescription"]
PLAY_MATCHUP_PITCHHAND: list[str] = ["pitcherHandCode", "pitcherHandDescription"]
PLAY_MATCHUP_BATTER: list[str] = ["batterId"]
PLAY_MATCHUP_PITCHER: list[str] = ["pitcherId"]
PLAY_MATCHUP_SPLITS: list[str] = ["menOnBase"]

PLAY_RUNNER_META: list[str] = ["gamePk", "atBatIndex"]

PLAY_RUNNER_MOVEMENT_FLAG = "movement"
PLAY_RUNNER_DETAILS_FLAG = "details"

PLAY_RUNNER_MOVEMENT: list[str] = ["endBase", "isOut", "outBase", "outNumber", "startBase"]
PLAY_RUNNER_DETAILS: list[str] = [
    "earned", "event", "eventType", "isScoringEvent", "movementReason",
    "playIndex", "rbi", "responsiblePitcherId", "teamUnearned", "runnerId",
]

PLAY_CREDIT_META: list[str] = ["gamePk", "atBatIndex"]

PLAY_CREDIT_CREDIT_FLAG = "credit"
PLAY_CREDIT_PLAYER_FLAG = "player"
PLAY_CREDIT_POSITION_FLAG = "position"

PLAY_CREDIT_CREDIT: list[str] = ["credit"]
PLAY_CREDIT_PLAYER: list[str] = ["playerId"]
PLAY_CREDIT_POSITION: list[str] = ["abbreviation", "code", "name", "type"]

# Pitch events
PITCH_META2_FLAG = "meta"
PITCH_DETAILS_FLAG = "details"
PITCH_COUNT_FLAG = "count"
PITCH_DATA_FLAG = "pitchData"
PITCH_DATA_COORD_FLAG = "coordinates"
PITCH_DATA_BREAKS_FLAG = "breaks"
PITCH_HIT_DATA_FLAG = "hitData"
PITCH_HIT_DATA_COORD_FLAG = "hit_coordinates"

PITCH_META: list[str] = ["atBatIndex", "gamePk"]
PITCH_META2: list[str] = ["index", "pfxId", "playId", "pitchNumber", "startTime", "endTime", "isPitch", "type"]
PITCH_DETAILS: list[str] = [
    "callCode", "callDescription", "description", "code", "ballColor", "trailColor",
    "isInPlay", "isStrike", "isBall", "typeCode", "typeDescription", "hasReview", "runnerGoing",
]
PITCH_COUNT: list[str] = ["balls", "strikes"]
PITCH_DATA: list[str] = ["startSpeed", "endSpeed", "strikeZoneTop", "strikeZoneBottom"]
PITCH_DATA_COORD: list[str] = [
    "aY", "aZ", "pfxX", "pfxZ", "pX", "pZ", "vX0", "vY0", "vZ0",
    "x", "y", "x0", "y0", "z0", "aX", "zone", "typeConfidence",
]
PITCH_DATA_BREAKS: list[str] = ["breakAngle", "breakLength", "breakY", "spinRate", "spinDirection"]
PITCH_HIT_DATA: list[str] = ["launchSpeed", "launchAngle", "totalDistance", "trajectory", "hardness", "location"]
PITCH_HIT_DATA_COORD: list[str] = ["coordX", "coordY"]

# Action events
ACTION_META2_FLAG = "meta"
ACTION_DETAILS_FLAG = "details"
ACTION_COUNT_FLAG = "count"
ACTION_PLAYER_FLAG = "player"
ACTION_POSITION_FLAG = "position"

ACTION_META: list[str] = ["atBatIndex", "gamePk"]
ACTION_META2: list[str] = ["index", "startTime", "endTime", "isPitch", "type", "battingOrder", "injuryType"]
ACTION_DETAILS: list[str] = [
    "description", "event", "awayScore", "homeScore", "isScoringPlay", "hasReview", "eventType",
]
ACTION_COUNT: list[str] = ["balls", "strikes", "outs"]
ACTION_PLAYER: list[str] = ["playerId"]
ACTION_POSITION: list[str] = ["abbreviation", "code", "name"]

# Pickoff events
PICKOFF_META2_FLAG = "meta"
PICKOFF_DETAILS_FLAG = "details"
PICKOFF_COUNT_FLAG = "count"

PICKOFF_META: list[str] = ["atBatIndex", "gamePk"]
PICKOFF_META2: list[str] = ["index", "playId", "isPitch"]
PICKOFF_DETAILS: list[str] = ["description", "code", "hasReview", "fromCatcher"]
PICKOFF_COUNT: list[str] = ["balls", "strikes", "outs"]

# ---------------------------------------------------------------------------
# Boxscore field definitions
# ---------------------------------------------------------------------------

BOX_INFO_META: list[str] = ["gamePk"]
BOX_INFO_FLAG = "info"
BOX_INFO_DETAILS: list[str] = ["weather", "wind", "attendance"]

BOX_OFFICIALS_META: list[str] = ["gamePk"]
BOX_OFFICIALS_FLAG = "officials"
BOX_OFFICIALS_DETAILS: list[str] = ["officialId", "position"]

BOX_PLAYER_META: list[str] = ["gamePk", "teamId", "teamType", "playerId"]

BOX_PLAYER_BATTING_FLAG = "batting"
BOX_PLAYER_PITCHING_FLAG = "pitching"
BOX_PLAYER_FIELDING_FLAG = "fielding"

BOX_PLAYER_META2: list[str] = ["link", "fullName"]

BOX_PLAYER_POSITION: list[str] = ["code", "name", "type", "abbreviation"]

BOX_PLAYER_BATTING_STATS: list[str] = [
    "atBats", "baseOnBalls", "catchersInterference", "caughtStealing", "doubles", "flyOuts",
    "groundIntoDoublePlay", "groundIntoTriplePlay", "groundOuts", "hitByPitch", "hits", "homeRuns",
    "intentionalWalks", "leftOnBase", "pickoffs", "rbi", "runs", "sacBunts",
    "sacFlies", "stolenBases", "strikeOuts", "totalBases", "triples",
]

BOX_PLAYER_PITCHING_STATS: list[str] = [
    "airOuts", "atBats", "balls", "baseOnBalls", "battersFaced", "blownSaves", "catchersInterference",
    "caughtStealing", "completeGames", "doubles", "earnedRuns", "gamesFinished", "gamesPitched",
    "gamesPlayed", "gamesStarted", "groundOuts", "hitBatsmen", "hits", "holds", "homeRuns",
    "inheritedRunners", "inheritedRunnersScored", "intentionalWalks", "losses", "numberOfPitches",
    "outs", "pickoffs", "pitchesThrown", "rbi", "runs", "sacBunts", "sacFlies", "saveOpportunities",
    "saves", "shutouts", "stolenBases", "strikeOuts", "strikes", "triples", "wildPitches", "wins",
]

BOX_PLAYER_FIELDING_STATS: list[str] = [
    "assists", "caughtStealing", "chances", "errors", "passedBall", "pickoffs", "putOuts", "stolenBases",
]

BOX_PLAYER_GAME_STATUS_FLAG = "gameStatus"
BOX_PLAYER_PERSON_FLAG = "person"
BOX_PLAYER_POSITION_FLAG = "position"

BOX_PLAYER_GAME_STATUS: list[str] = ["isSubstitute", "isOnBench", "isCurrentPitcher", "isCurrentBatter"]
BOX_PLAYER_PERSON: list[str] = ["fullName", "link"]
BOX_PLAYER_POSITION: list[str] = ["abbreviation", "code", "name", "type"]

BOX_PLAYER_ALL_POSITIONS_FLAG = "allPositions"
BOX_PLAYER_ALL_POSITIONS: list[str] = ["code", "name", "type", "abbreviation"]

BOX_TEAM_META: list[str] = ["gamePk", "teamId", "teamType"]

BOX_TEAM_META2_FLAG = "meta"
BOX_TEAM_BATTING_FLAG = "batting"
BOX_TEAM_PITCHING_FLAG = "pitching"
BOX_TEAM_FIELDING_FLAG = "fielding"
BOX_TEAM_VENUE_FLAG = "venue"
BOX_TEAM_LEAGUE_FLAG = "league"
BOX_TEAM_DIVISION_FLAG = "division"

BOX_TEAM_META2: list[str] = [
    "abbreviation", "active", "allStarStatus", "fileCode", "firstYearOfPlay",
    "locationName", "parentOrgId", "parentOrgName", "season", "shortName",
    "teamCode", "teamName", "id", "name", "link",
]

BOX_TEAM_VENUE: list[str] = ["venueId", "venueName", "venueLink"]
BOX_TEAM_LEAGUE: list[str] = ["leagueId", "leagueName", "leagueLink"]
BOX_TEAM_DIVISION: list[str] = ["divisionId", "divisionName", "divisionLink"]

BOX_TEAM_BATTING_STATS: list[str] = [
    "atBats", "baseOnBalls", "catchersInterference", "caughtStealing", "doubles", "flyOuts",
    "groundIntoDoublePlay", "groundIntoTriplePlay", "groundOuts", "hitByPitch", "hits", "homeRuns",
    "intentionalWalks", "leftOnBase", "pickoffs", "rbi", "runs", "sacBunts",
    "sacFlies", "stolenBases", "strikeOuts", "totalBases", "triples",
]

BOX_TEAM_FIELDING_STATS: list[str] = [
    "assists", "caughtStealing", "chances", "errors", "passedBall", "pickoffs", "putOuts", "stolenBases",
]

BOX_TEAM_PITCHING_STATS: list[str] = [
    "airOuts", "atBats", "baseOnBalls", "battersFaced", "catchersInterference", "caughtStealing",
    "completeGames", "doubles", "earnedRuns", "groundOuts", "hitBatsmen", "hits", "homeRuns",
    "inheritedRunners", "inheritedRunnersScored", "intentionalWalks", "outs", "pickoffs", "rbi",
    "runs", "sacBunts", "sacFlies", "saveOpportunities", "shutouts", "stolenBases", "strikeOuts",
    "triples", "wildPitches",
]

BOX_TEAM_BATTING_ORDER_META: list[str] = ["gamePk", "teamId", "teamType"]
BOX_TEAM_BATTING_ORDER_FIELDS: list[str] = ["playerId", "battingOrder"]
