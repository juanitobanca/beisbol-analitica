DROP TABLE IF EXISTS runners;

CREATE TABLE runners (
  gamePk INTEGER,
  inning INTEGER,
  halfInning TEXT,
  pitchingTeamId INTEGER,
  battingTeamId INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  event TEXT,
  eventType TEXT,
  isScoringPlay INTEGER,
  movementReason TEXT,
  rbi INTEGER,
  responsiblePitcherId INTEGER,
  runnerId INTEGER,
  startBase TEXT,
  endBase TEXT,
  isOut INTEGER,
  outBase TEXT,
  outNumber INTEGER,
  earned INTEGER,
  teamUnearned INTEGER
);

CREATE INDEX IF NOT EXISTS idx_runners_gamePk_atBatIndex ON runners(gamePk, atBatIndex);
