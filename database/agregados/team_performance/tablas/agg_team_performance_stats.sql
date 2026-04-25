DROP TABLE IF EXISTS agg_team_performance_stats;

CREATE TABLE agg_team_performance_stats (
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
  runs INTEGER,
  runsAllowed INTEGER,
  runDifferential INTEGER,
  wins INTEGER,
  losses INTEGER,
  winPercentage REAL,
  pythagoreanExpectation REAL,
  attendance INTEGER,
  -- Atributos
  majorLeague TEXT,
  teamName TEXT,
  venueName TEXT
);

CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_groupingId ON agg_team_performance_stats(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_groupingDescription ON agg_team_performance_stats(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_majorLeagueId ON agg_team_performance_stats(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_seasonId ON agg_team_performance_stats(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_venueId ON agg_team_performance_stats(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_teamId ON agg_team_performance_stats(teamId);
