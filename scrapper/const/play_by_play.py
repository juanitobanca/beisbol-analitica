"""Field and flag constants for the play-by-play scraper."""

# ---------------------------------------------------------------------------
# At-bat
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

# ---------------------------------------------------------------------------
# Matchup
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

PLAY_RUNNER_META: list[str] = ["gamePk", "atBatIndex"]

PLAY_RUNNER_MOVEMENT_FLAG = "movement"
PLAY_RUNNER_DETAILS_FLAG = "details"

PLAY_RUNNER_MOVEMENT: list[str] = ["endBase", "isOut", "outBase", "outNumber", "startBase"]
PLAY_RUNNER_DETAILS: list[str] = [
    "earned", "event", "eventType", "isScoringEvent", "movementReason",
    "playIndex", "rbi", "responsiblePitcherId", "teamUnearned", "runnerId",
]

# ---------------------------------------------------------------------------
# Credit
# ---------------------------------------------------------------------------

PLAY_CREDIT_META: list[str] = ["gamePk", "atBatIndex"]

PLAY_CREDIT_CREDIT_FLAG = "credit"
PLAY_CREDIT_PLAYER_FLAG = "player"
PLAY_CREDIT_POSITION_FLAG = "position"

PLAY_CREDIT_CREDIT: list[str] = ["credit"]
PLAY_CREDIT_PLAYER: list[str] = ["playerId"]
PLAY_CREDIT_POSITION: list[str] = ["abbreviation", "code", "name", "type"]

# ---------------------------------------------------------------------------
# Pitch events
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Action events
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Pickoff events
# ---------------------------------------------------------------------------

PICKOFF_META2_FLAG = "meta"
PICKOFF_DETAILS_FLAG = "details"
PICKOFF_COUNT_FLAG = "count"

PICKOFF_META: list[str] = ["atBatIndex", "gamePk"]
PICKOFF_META2: list[str] = ["index", "playId", "isPitch"]
PICKOFF_DETAILS: list[str] = ["description", "code", "hasReview", "fromCatcher"]
PICKOFF_COUNT: list[str] = ["balls", "strikes", "outs"]
