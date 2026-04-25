DROP TABLE IF EXISTS agg_fielding_stats;

CREATE TABLE agg_fielding_stats (
  groupingId INTEGER,
  groupingDescription TEXT,
  aggregationType TEXT,
  majorLeagueId INTEGER,
  seasonId INTEGER,
  gameDate TEXT,
  gameType2 TEXT,
  teamType TEXT,
  venueId INTEGER,
  teamId INTEGER,
  positionAbbrev TEXT,
  playerId INTEGER,
  assists INTEGER,
  catcherInterferences INTEGER,
  errors INTEGER,
  games INTEGER,
  putOuts INTEGER,
  totalChances INTEGER,
  outsPlayed INTEGER,
  inningsPlayed REAL,
  gamesPlayed REAL,
  fieldingPercentage REAL,
  rangeFactorPerInning REAL,
  rangeFactorPerGame REAL,
  -- Atributos
  majorLeague TEXT,
  playerName TEXT,
  teamName TEXT,
  venueName TEXT
);

CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_groupingId ON agg_fielding_stats(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_majorLeagueId ON agg_fielding_stats(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_seasonId ON agg_fielding_stats(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_venueId ON agg_fielding_stats(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_teamId ON agg_fielding_stats(teamId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_playerId ON agg_fielding_stats(playerId);
