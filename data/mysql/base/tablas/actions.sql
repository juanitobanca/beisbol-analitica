USE baseball;

DROP TABLE actions;

CREATE TABLE actions (
  gamePk INTEGER,
  inning INTEGER,
  halfInning VARCHAR(15),
  pitchingTeamId INTEGER,
  battingTeamId INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  playerId INTEGER,
  endOuts INTEGER,
  endBalls INTEGER,
  endStrikes INTEGER,
  hasReview TINYINT,
  isScoringPlay TINYINT,
  awayScore INTEGER,
  homeScore INTEGER,
  event VARCHAR(50),
  eventType VARCHAR(50),
  battingOrder INTEGER,
  positionAbbrev VARCHAR(10),
  injuryType VARCHAR(50),
  description VARCHAR(700)
) ENGINE = INNODB;

ALTER TABLE actions ADD INDEX(gamePk, atBatIndex);
