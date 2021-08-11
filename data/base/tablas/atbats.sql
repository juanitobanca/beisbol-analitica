USE baseball;

DROP TABLE atbats;

CREATE TABLE atbats (
  gamePk INTEGER,
  inning INTEGER,
  halfInning VARCHAR(15),
  atBatIndex INTEGER,
  battingTeamId INTEGER,
  pitchingTeamId INTEGER,
  endOuts INTEGER,
  endBalls INTEGER,
  endStrikes INTEGER,
  batterId INTEGER,
  pitcherId INTEGER,
  hasOut TINYINT,
  hasReview TINYINT,
  isScoringPlay TINYINT,
  rbi INTEGER,
  awayScore INTEGER,
  homeScore INTEGER,
  event VARCHAR(100),
  eventType VARCHAR(100),
  batSide VARCHAR(1),
  pitchHand VARCHAR(1),
  menOnBase VARCHAR(10),
  description VARCHAR(700),
  HM4 VARCHAR(10),
  HM8 VARCHAR(10)
) ENGINE = INNODB;

ALTER TABLE atbats ADD PRIMARY KEY(gamePk, atBatIndex);
