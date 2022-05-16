DROP TABLE IF EXISTS agg_fielding_stats; 

CREATE TABLE agg_fielding_stats (
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
majorLeague TEXT,
playerName TEXT,
teamName TEXT,
venueName TEXT
);

CREATE INDEX groupingId_agg_fielding_stats ON agg_fielding_stats(groupingId);
CREATE INDEX majorLeagueId_agg_fielding_stats ON agg_fielding_stats(majorLeagueId);
CREATE INDEX playerId_agg_fielding_stats ON agg_fielding_stats(playerId);
CREATE INDEX seasonId_agg_fielding_stats ON agg_fielding_stats(seasonId);
CREATE INDEX teamId_agg_fielding_stats ON agg_fielding_stats(teamId);
CREATE INDEX venueId_agg_fielding_stats ON agg_fielding_stats(venueId);