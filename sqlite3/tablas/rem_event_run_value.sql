DROP TABLE IF EXISTS rem_event_run_value; 

CREATE TABLE rem_event_run_value (
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