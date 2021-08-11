USE baseball;

DROP TABLE pitches;


CREATE TABLE pitches (
  gamePk INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  inning INTEGER,
  halfInning VARCHAR(15),
  battingTeamId INTEGER,
  pitchingTeamId INTEGER,
  batterId INTEGER,
  pitcherId INTEGER,
  pitchNumber INTEGER,
  startBalls INTEGER,
  startStrikes INTEGER,
  endBalls INTEGER,
  endStrikes INTEGER,
  callCode VARCHAR(2),
  callDescription VARCHAR(50),
  callDescription2 VARCHAR(50),
  code VARCHAR(2),
  isInPlay TINYINT,
  isStrike TINYINT,
  isBall TINYINT,
  typeCode VARCHAR(100),
  typeDescription VARCHAR(100),
  hasReview TINYINT,
  runnerGoing TINYINT,
  strikeZoneTop DOUBLE,
  strikeZoneBottom DOUBLE,
  x DOUBLE,
  y DOUBLE,
  x0 DOUBLE,
  y0 DOUBLE,
  trajectory VARCHAR(100),
  hardness VARCHAR(100),
  location INTEGER,
  coordX DOUBLE,
  coordY DOUBLE,
  HM4 VARCHAR(10),
  HM8 VARCHAR(10)
) ENGINE = INNODB;

ALTER TABLE pitches ADD INDEX(gamePk, atBatIndex);
