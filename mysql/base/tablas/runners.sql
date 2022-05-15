USE baseball;

DROP TABLE runners;

CREATE TABLE runners (
  gamePk INTEGER,
  inning INTEGER,
  halfInning VARCHAR(15),
  pitchingTeamId INTEGER,
  battingTeamId INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  event VARCHAR(100),
  eventType VARCHAR(100),
  isScoringPlay TINYINT,
  movementReason VARCHAR(100),
  rbi TINYINT,
  responsiblePitcherId INTEGER,
  runnerId INTEGER,
  startBase VARCHAR(10),
  endBase VARCHAR(10),
  isOut TINYINT,
  outBase VARCHAR(10),
  outNumber INTEGER,
  earned TINYINT,
  teamUnearned TINYINT
) ENGINE = INNODB;

ALTER TABLE runners ADD INDEX(gamePk, atBatIndex);
