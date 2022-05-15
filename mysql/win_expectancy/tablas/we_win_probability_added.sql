USE baseball;

DROP TABLE we_win_probability_added;

CREATE TABLE IF NOT EXISTS we_win_probability_added (
  groupingId INTEGER UNSIGNED,
  groupingDescription VARCHAR(255),
  groupingFields VARCHAR(255),
  majorLeagueId INTEGER,
  seasonId DOUBLE,
  gameType2 VARCHAR(10),
  teamId INTEGER,
  playerId INTEGER,
  offensiveWinProbabilityAdded DOUBLE,
  defensiveWinProbabilityAdded DOUBLE
);

ALTER TABLE we_win_probability_added ADD INDEX( groupingId );
ALTER TABLE we_win_probability_added ADD INDEX( majorLeagueId );
ALTER TABLE we_win_probability_added ADD INDEX( teamId );
ALTER TABLE we_win_probability_added ADD INDEX( playerId );
