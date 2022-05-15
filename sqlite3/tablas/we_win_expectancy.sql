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