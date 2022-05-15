USE baseball;

DROP TABLE stg_play_credit;

CREATE TABLE IF NOT EXISTS stg_play_credit (
  credit VARCHAR(100),
  playerId INTEGER,
  abbreviation VARCHAR(100),
  code VARCHAR(100),
  name VARCHAR(100),
  type VARCHAR(100),
  gamePk INTEGER,
  atBatIndex INTEGER
) ENGINE = INNODB;
