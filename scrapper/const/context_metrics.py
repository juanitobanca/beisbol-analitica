"""Field and flag constants for the context metrics scraper."""

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
