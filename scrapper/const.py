"""Field schema definitions for all MLB Stats API scrapers.

Utilities and infrastructure that previously lived here have been split into
focused modules:

    http_client  — HTTP session and retry logic
    endpoints    — URL construction per endpoint
    dataset      — Dataset type, create_dataset(), json_is_valid()
    mappings     — SPORT_ID / LEAGUE_ID lookup tables
    table_names  — STG_* staging table name constants

The imports below keep every existing ``import const as c`` call working
without modification.  Once the rest of the codebase is updated to import
from the focused modules directly, these re-exports can be removed.
"""

# ---------------------------------------------------------------------------
# Compatibility re-exports — remove once callers are updated
# ---------------------------------------------------------------------------

from dataset import Dataset, create_dataset, json_is_valid  # noqa: F401
from endpoints import (  # noqa: F401
    game_url,
    people_url,
    people_batch_url,
    schedule_url,
    transactions_url,
)
from http_client import http_client  # noqa: F401
from mappings import SPORT_ID, LEAGUE_ID  # noqa: F401
from table_names import (  # noqa: F401
    STG_TRANSACTIONS, STG_GAME_CONTEXT,
    STG_BOX_TEAM_BATTING, STG_BOX_TEAM_PITCHING, STG_BOX_TEAM_FIELDING,
    STG_BOX_PLAYER_BATTING, STG_BOX_PLAYER_PITCHING, STG_BOX_PLAYER_FIELDING,
    STG_PLAYERS, STG_OFFICIALS,
    STG_BOX_TEAM_BATTING_ORDER, STG_BOX_TEAM, STG_BOX_PLAYER_GAME_POSITIONS,
    STG_BOX_PLAYER_GAME_INFO, STG_BOX_INFO, STG_BOX_OFFICIALS,
    STG_PLAY_ATBAT, STG_PLAY_RUNNER, STG_PLAY_CREDIT,
    STG_PLAY_PITCH, STG_PLAY_ACTION, STG_PLAY_PICKOFF,
)

# ---------------------------------------------------------------------------
# Endpoint string identifiers (used as keys inside game_url())
# ---------------------------------------------------------------------------

ENDPOINT_PLAY_BY_PLAY = "playByPlay"
ENDPOINT_BOXSCORE = "boxscore"
ENDPOINT_CONTEXT_METRICS = "contextMetrics"
ENDPOINT_PEOPLE = "people"
ENDPOINT_PEOPLE_BATCH = "people_batch"
ENDPOINT_SCHEDULE = "schedule"
ENDPOINT_TRANSACTIONS = "transactions"

# ---------------------------------------------------------------------------
# parse_json() — kept here during migration so callers don't break.
# New code should build URLs via endpoints.py and fetch via http_client.py.
# ---------------------------------------------------------------------------

import logging  # noqa: E402  (after re-exports intentionally)

logger = logging.getLogger(__name__)


def parse_json(parsing_arg: str | int, endpoint: str) -> dict:
    """Fetch JSON from the MLB Stats API.

    .. deprecated::
        Build URLs with :mod:`endpoints` and fetch with :mod:`http_client`
        directly.  This wrapper exists only for backward compatibility.
    """
    from endpoints import (
        game_url, people_url, people_batch_url, schedule_url, transactions_url,
    )
    from http_client import http_client as _client

    if endpoint == ENDPOINT_PEOPLE_BATCH:
        url = people_batch_url([int(i) for i in str(parsing_arg).split(",")])
    elif endpoint == ENDPOINT_PEOPLE:
        url = people_url(int(parsing_arg))
    elif endpoint == ENDPOINT_TRANSACTIONS:
        url = f"from_legacy:{parsing_arg}"  # transactions_url requires structured args
        # Fall back to raw construction to avoid breaking the Transactions scraper
        from config import settings
        url = f"{settings.base_url}/transactions?{parsing_arg}"
    elif endpoint == ENDPOINT_SCHEDULE:
        url = schedule_url(str(parsing_arg))
    else:
        url = game_url(int(parsing_arg), endpoint)

    return _client.get_json(url)


# ---------------------------------------------------------------------------
# default_missing_value — kept for backward compatibility only.
# Use dict.get(key, default) directly in new code.
# ---------------------------------------------------------------------------

from typing import Any  # noqa: E402


def default_missing_value(d: dict | None, k: str, v: Any = None) -> Any:
    """Return ``d.get(k)`` or *v* if *d* is falsy.

    .. deprecated::
        Use ``d.get(k)`` or ``d.get(k, default)`` directly.
    """
    if not d:
        return v
    return d.get(k)


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
