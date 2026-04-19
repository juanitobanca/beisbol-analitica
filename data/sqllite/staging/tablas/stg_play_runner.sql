DROP TABLE IF EXISTS stg_play_runner;

CREATE TABLE IF NOT EXISTS stg_play_runner (
  endBase TEXT,
  isOut INTEGER,
  outBase TEXT,
  outNumber REAL,
  startBase TEXT,
  earned INTEGER,
  event TEXT,
  eventType TEXT,
  isScoringEvent INTEGER,
  movementReason TEXT,
  playIndex INTEGER,
  rbi INTEGER,
  responsiblePitcherId INTEGER,
  teamUnearned INTEGER,
  runnerId INTEGER,
  gamePk INTEGER,
  atBatIndex INTEGER
);
