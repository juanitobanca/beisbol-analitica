DROP TABLE IF EXISTS games;

CREATE TABLE games (
  gamePk INTEGER,
  gameType TEXT,
  gameType2 TEXT,
  seasonId INTEGER,
  gameDate TEXT,
  isTie INTEGER,
  gameNumber INTEGER,
  majorLeague TEXT,
  majorLeagueId INTEGER,
  doubleHeader TEXT,
  dayNight TEXT,
  scheduledInnings INTEGER,
  gamesInSeries INTEGER,
  seriesDescription TEXT,
  ifNecessaryDescription TEXT,
  gameId TEXT,
  abstractGameState TEXT,
  codedGameState TEXT,
  detailedState TEXT,
  awayWins INTEGER,
  awayLosses INTEGER,
  awayPct REAL,
  awayScore INTEGER,
  awayTeamId INTEGER,
  awayIsWinner INTEGER,
  homeWins INTEGER,
  homeLosses INTEGER,
  homePct REAL,
  homeScore INTEGER,
  homeTeamId INTEGER,
  homeIsWinner INTEGER,
  venueId INTEGER,
  homeTeamName TEXT,
  awayTeamName TEXT,
  venueName TEXT,
  weather TEXT,
  wind TEXT,
  attendance INTEGER,
  PRIMARY KEY (gamePk, majorLeagueId)
);

CREATE INDEX IF NOT EXISTS idx_games_seasonId ON games(seasonId);
CREATE INDEX IF NOT EXISTS idx_games_homeTeamId ON games(homeTeamId);
CREATE INDEX IF NOT EXISTS idx_games_awayTeamId ON games(awayTeamId);
CREATE INDEX IF NOT EXISTS idx_games_venueId ON games(venueId);
