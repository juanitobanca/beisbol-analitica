USE baseball;

DROP TABLE game_officials;

CREATE TABLE game_officials (
  gamePk INTEGER,
  officialId INTEGER,
  position VARCHAR(100)
) ENGINE = INNODB;

ALTER TABLE game_officials ADD INDEX(gamePk);
