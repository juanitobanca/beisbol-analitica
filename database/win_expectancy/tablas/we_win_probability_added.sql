DROP TABLE IF EXISTS we_win_probability_added;

CREATE TABLE IF NOT EXISTS we_win_probability_added (
  groupingId INTEGER,
  groupingDescription TEXT,
  groupingFields TEXT,
  majorLeagueId INTEGER,
  seasonId REAL,
  gameType2 TEXT,
  teamId INTEGER,
  playerId INTEGER,
  offensiveWinProbabilityAdded REAL,
  defensiveWinProbabilityAdded REAL
);

CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_groupingId ON we_win_probability_added(groupingId);
CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_majorLeagueId ON we_win_probability_added(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_teamId ON we_win_probability_added(teamId);
CREATE INDEX IF NOT EXISTS idx_we_win_probability_added_playerId ON we_win_probability_added(playerId);
