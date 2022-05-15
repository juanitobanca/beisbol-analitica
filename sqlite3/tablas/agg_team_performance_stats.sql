DROP TABLE IF EXISTS agg_team_performance_stats; 

CREATE TABLE agg_team_performance_stats (
groupingId INTEGER,
groupingDescription TEXT,
aggregationType TEXT,
majorLeagueId INTEGER,
seasonId REAL,
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
majorLeague TEXT,
teamName TEXT,
venueName TEXT
);