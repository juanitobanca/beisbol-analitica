USE baseball;

DROP TABLE stg_play_pickoff;

CREATE TABLE IF NOT EXISTS stg_play_pickoff (
  description VARCHAR(700),
  code VARCHAR(100),
  hasReview TINYINT,
  fromCatcher TINYINT,
  balls VARCHAR(100),
  strikes VARCHAR(100),
  outs VARCHAR(100),
  atBatIndex INTEGER,
  gamePk INTEGER,
  `index` INTEGER,
  playId VARCHAR(100),
  isPitch TINYINT
) ENGINE = INNODB;
