DROP TABLE IF EXISTS rem_run_expectancy_matrix;

CREATE TABLE IF NOT EXISTS rem_run_expectancy_matrix (
  groupingId INTEGER,
  groupingDescription TEXT,
  majorLeagueId INTEGER,
  seasonId REAL,
  venueId INTEGER,
  runnersBeforePlay TEXT,
  zeroOutsRunsScoredEndInning INTEGER,
  zeroOutsRunsScoredBeforePlay INTEGER,
  zeroOutsEvents INTEGER,
  zeroOutsRunExpectancy REAL,
  oneOutsRunsScoredEndInning INTEGER,
  oneOutsRunsScoredBeforePlay INTEGER,
  oneOutsEvents INTEGER,
  oneOutsRunExpectancy REAL,
  twoOutsRunsScoredEndInning INTEGER,
  twoOutsRunsScoredBeforePlay INTEGER,
  twoOutsEvents INTEGER,
  twoOutsRunExpectancy REAL,
  sortingOrder INTEGER,
  majorLeague TEXT,
  venueName TEXT
);

CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_groupingId ON rem_run_expectancy_matrix(groupingId);
CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_majorLeagueId ON rem_run_expectancy_matrix(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_seasonId ON rem_run_expectancy_matrix(seasonId);
CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_venueId ON rem_run_expectancy_matrix(venueId);
