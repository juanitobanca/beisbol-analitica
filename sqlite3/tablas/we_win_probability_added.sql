DROP TABLE IF EXISTS we_win_probability_added; 

CREATE TABLE we_win_probability_added (
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