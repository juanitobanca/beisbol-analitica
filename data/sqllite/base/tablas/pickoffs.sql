USE baseball;

DROP TABLE pickoffs;

CREATE TABLE pickoffs (
  gamePk INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  outs INTEGER,
  balls INTEGER,
  strikes INTEGER,
  fromCatcher TINYINT,
  hasReview TINYINT,
  baseCode INTEGER
) ENGINE = INNODB;

ALTER TABLE pickoffs ADD INDEX(gamePk, atBatIndex);
