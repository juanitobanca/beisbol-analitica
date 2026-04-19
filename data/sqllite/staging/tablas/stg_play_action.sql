USE baseball;

DROP TABLE stg_play_action;

CREATE TABLE IF NOT EXISTS stg_play_action (
  description VARCHAR(700),
  event VARCHAR(100),
  awayScore INTEGER,
  homeScore INTEGER,
  isScoringPlay TINYINT,
  hasReview TINYINT,
  eventType VARCHAR(100),
  balls INTEGER,
  strikes INTEGER,
  outs INTEGER,
  playerId INTEGER,
  abbreviation VARCHAR(100),
  code VARCHAR(100),
  name VARCHAR(100),
  atBatIndex INTEGER,
  gamePk INTEGER,
  `index` INTEGER,
  startTime VARCHAR(100),
  endTime VARCHAR(100),
  isPitch TINYINT,
  type VARCHAR(100),
  battingOrder VARCHAR(100),
  injuryType VARCHAR(100)
) ENGINE = INNODB;
