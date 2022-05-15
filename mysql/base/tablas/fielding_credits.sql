USE baseball;

DROP TABLE fielding_credits;

CREATE TABLE fielding_credits (
  gamePk INTEGER,
  atBatIndex INTEGER,
  playerId INTEGER,
  positionAbbrev VARCHAR(10),
  credit VARCHAR(30)
) ENGINE = INNODB;

ALTER TABLE fielding_credits ADD INDEX(gamePk, atBatIndex);
