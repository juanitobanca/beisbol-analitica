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

CREATE INDEX groupingDescription_agg_team_performance_stats ON agg_team_performance_stats(groupingDescription);
CREATE INDEX groupingId_agg_team_performance_stats ON agg_team_performance_stats(groupingId);
CREATE INDEX majorLeagueId_agg_team_performance_stats ON agg_team_performance_stats(majorLeagueId);
CREATE INDEX seasonId_agg_team_performance_stats ON agg_team_performance_stats(seasonId);
CREATE INDEX teamId_agg_team_performance_stats ON agg_team_performance_stats(teamId);
CREATE INDEX venueId_agg_team_performance_stats ON agg_team_performance_stats(venueId);