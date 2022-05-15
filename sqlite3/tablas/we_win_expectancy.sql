DROP TABLE IF EXISTS we_win_expectancy; 

CREATE TABLE we_win_expectancy (
groupingId INTEGER,
groupingDescription TEXT,
majorLeagueId INTEGER,
seasonId REAL,
gameType2 TEXT,
inning INTEGER,
menOnBase TEXT,
outs INTEGER,
score TEXT,
games INTEGER,
wins INTEGER,
losses INTEGER,
winExpectancy REAL
);

CREATE INDEX groupingId_we_win_expectancy ON we_win_expectancy(groupingId);
CREATE INDEX majorLeagueId_we_win_expectancy ON we_win_expectancy(majorLeagueId);
CREATE INDEX seasonId_we_win_expectancy ON we_win_expectancy(seasonId);