DROP TABLE IF EXISTS we_win_expectancy;

CREATE TABLE IF NOT EXISTS we_win_expectancy (
  groupingId INTEGER,
  groupingDescription TEXT,
  majorLeagueId INTEGER,
  seasonId INTEGER,
  gameType2 TEXT,
  inning INTEGER,
  menOnBase TEXT,
  outs INTEGER,
  score TEXT,
  games INTEGER,
  wins INTEGER,
  losses INTEGER,
  winExpectancy REAL
);

CREATE INDEX IF NOT EXISTS idx_we_win_expectancy_groupingId ON we_win_expectancy(groupingId);
CREATE INDEX IF NOT EXISTS idx_we_win_expectancy_majorLeagueId ON we_win_expectancy(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_we_win_expectancy_seasonId ON we_win_expectancy(seasonId);
