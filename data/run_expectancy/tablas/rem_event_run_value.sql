USE baseball;

DROP TABLE rem_event_run_value;

CREATE TABLE IF NOT EXISTS rem_event_run_value (
  majorLeagueId INTEGER,
  seasonId DOUBLE,
  venueId INTEGER,
  event VARCHAR(100),
  startRunExpectancy DOUBLE,
  runsScoredInPlay DOUBLE,
  endRunExpectancy DOUBLE,
  events INTEGER,
  runValue DOUBLE,
  groupingId INTEGER,
  groupingDescription VARCHAR(100),
  majorLeagueName VARCHAR(10),
  venueName VARCHAR(100)
);

ALTER TABLE rem_event_run_value ADD INDEX(groupingId);
ALTER TABLE rem_event_run_value ADD INDEX(majorLeagueId);
ALTER TABLE rem_event_run_value ADD INDEX(venueId);
