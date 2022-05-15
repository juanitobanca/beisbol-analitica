USE baseball;

DROP TABLE we_win_expectancy;

CREATE TABLE IF NOT EXISTS we_win_expectancy (
  groupingId INTEGER UNSIGNED,
  groupingDescription VARCHAR(255),
  majorLeagueId INTEGER,
  seasonId DOUBLE,
  gameType2 VARCHAR(10),
  inning INTEGER,
  menOnBase VARCHAR(10),
  outs INTEGER,
  score VARCHAR(10),
  games INTEGER,
  wins INTEGER,
  losses INTEGER,
  winExpectancy DOUBLE
);

ALTER TABLE we_win_expectancy ADD INDEX( groupingId );
ALTER TABLE we_win_expectancy ADD INDEX( majorLeagueId );
ALTER TABLE we_win_expectancy ADD INDEX( seasonId );
