"""Field and flag constants for the boxscore scraper."""

# ---------------------------------------------------------------------------
# Game info
# ---------------------------------------------------------------------------

BOX_INFO_META: list[str] = ["gamePk"]
BOX_INFO_FLAG = "info"
BOX_INFO_DETAILS: list[str] = ["weather", "wind", "attendance"]

# ---------------------------------------------------------------------------
# Officials
# ---------------------------------------------------------------------------

BOX_OFFICIALS_META: list[str] = ["gamePk"]
BOX_OFFICIALS_FLAG = "officials"
BOX_OFFICIALS_DETAILS: list[str] = ["officialId", "position"]

# ---------------------------------------------------------------------------
# Player
# ---------------------------------------------------------------------------

BOX_PLAYER_META: list[str] = ["gamePk", "teamId", "teamType", "playerId"]

BOX_PLAYER_BATTING_FLAG = "batting"
BOX_PLAYER_PITCHING_FLAG = "pitching"
BOX_PLAYER_FIELDING_FLAG = "fielding"
BOX_PLAYER_GAME_STATUS_FLAG = "gameStatus"
BOX_PLAYER_PERSON_FLAG = "person"
BOX_PLAYER_POSITION_FLAG = "position"
BOX_PLAYER_ALL_POSITIONS_FLAG = "allPositions"

BOX_PLAYER_META2: list[str] = ["link", "fullName"]
BOX_PLAYER_POSITION: list[str] = ["code", "name", "type", "abbreviation"]
BOX_PLAYER_GAME_STATUS: list[str] = ["isSubstitute", "isOnBench", "isCurrentPitcher", "isCurrentBatter"]
BOX_PLAYER_PERSON: list[str] = ["fullName", "link"]
BOX_PLAYER_ALL_POSITIONS: list[str] = ["code", "name", "type", "abbreviation"]

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

# ---------------------------------------------------------------------------
# Team
# ---------------------------------------------------------------------------

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
BOX_TEAM_PITCHING_STATS: list[str] = [
    "airOuts", "atBats", "baseOnBalls", "battersFaced", "catchersInterference", "caughtStealing",
    "completeGames", "doubles", "earnedRuns", "groundOuts", "hitBatsmen", "hits", "homeRuns",
    "inheritedRunners", "inheritedRunnersScored", "intentionalWalks", "outs", "pickoffs", "rbi",
    "runs", "sacBunts", "sacFlies", "saveOpportunities", "shutouts", "stolenBases", "strikeOuts",
    "triples", "wildPitches",
]
BOX_TEAM_FIELDING_STATS: list[str] = [
    "assists", "caughtStealing", "chances", "errors", "passedBall", "pickoffs", "putOuts", "stolenBases",
]

# ---------------------------------------------------------------------------
# Batting order
# ---------------------------------------------------------------------------

BOX_TEAM_BATTING_ORDER_META: list[str] = ["gamePk", "teamId", "teamType"]
BOX_TEAM_BATTING_ORDER_FIELDS: list[str] = ["playerId", "battingOrder"]
