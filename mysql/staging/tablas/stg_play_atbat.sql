USE baseball;

DROP TABLE stg_play_atbat;

CREATE TABLE IF NOT EXISTS stg_play_atbat (
  atBatIndex INTEGER,
  captivatingIndex INTEGER,
  endTime VARCHAR(100),
  halfInning VARCHAR(100),
  hasOut TINYINT,
  hasReview TINYINT,
  inning INTEGER,
  isComplete TINYINT,
  isScoringPlay TINYINT,
  startTime VARCHAR(100),
  awayScore INTEGER,
  description VARCHAR(700),
  event VARCHAR(100),
  eventType VARCHAR(100),
  homeScore INTEGER,
  rbi INTEGER,
  type VARCHAR(100),
  balls INTEGER,
  outs INTEGER,
  strikes INTEGER,
  batterSideCode VARCHAR(100),
  batterSideDescription VARCHAR(100),
  pitcherHandCode VARCHAR(100),
  pitcherHandDescription VARCHAR(100),
  pitcherId INTEGER,
  batterId INTEGER,
  menOnBase VARCHAR(100),
  gamePk INTEGER
) ENGINE = INNODB;
