DROP TABLE IF EXISTS rem_event_run_value;

CREATE TABLE IF NOT EXISTS rem_event_run_value (
  majorLeagueId INTEGER,
  seasonId REAL,
  venueId INTEGER,
  event TEXT,
  startRunExpectancy REAL,
  runsScoredInPlay REAL,
  endRunExpectancy REAL,
  events INTEGER,
  runValue REAL,
  groupingId INTEGER,
  groupingDescription TEXT,
  majorLeague TEXT,
  venueName TEXT
);

CREATE INDEX IF NOT EXISTS idx_rem_event_run_value_groupingId ON rem_event_run_value(groupingId);
CREATE INDEX IF NOT EXISTS idx_rem_event_run_value_majorLeagueId ON rem_event_run_value(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_rem_event_run_value_venueId ON rem_event_run_value(venueId);
