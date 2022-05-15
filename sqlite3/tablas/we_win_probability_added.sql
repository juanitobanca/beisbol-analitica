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

CREATE INDEX groupingId_we_win_probability_added ON we_win_probability_added(groupingId);
CREATE INDEX majorLeagueId_we_win_probability_added ON we_win_probability_added(majorLeagueId);
CREATE INDEX playerId_we_win_probability_added ON we_win_probability_added(playerId);
CREATE INDEX teamId_we_win_probability_added ON we_win_probability_added(teamId);