DROP TABLE IF EXISTS stg_play_action;

CREATE TABLE IF NOT EXISTS stg_play_action (
  description TEXT,
  event TEXT,
  awayScore INTEGER,
  homeScore INTEGER,
  isScoringPlay INTEGER,
  hasReview INTEGER,
  eventType TEXT,
  balls INTEGER,
  strikes INTEGER,
  outs INTEGER,
  playerId INTEGER,
  abbreviation TEXT,
  code TEXT,
  name TEXT,
  atBatIndex INTEGER,
  gamePk INTEGER,
  `index` INTEGER,
  startTime TEXT,
  endTime TEXT,
  isPitch INTEGER,
  type TEXT,
  battingOrder TEXT,
  injuryType TEXT
);
