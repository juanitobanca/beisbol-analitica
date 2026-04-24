DROP TABLE IF EXISTS actions;

CREATE TABLE actions (
  gamePk INTEGER,
  inning INTEGER,
  halfInning TEXT,
  pitchingTeamId INTEGER,
  battingTeamId INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  playerId INTEGER,
  endOuts INTEGER,
  endBalls INTEGER,
  endStrikes INTEGER,
  hasReview INTEGER,
  isScoringPlay INTEGER,
  awayScore INTEGER,
  homeScore INTEGER,
  event TEXT,
  eventType TEXT,
  battingOrder INTEGER,
  positionAbbrev TEXT,
  injuryType TEXT,
  description TEXT
);

CREATE INDEX IF NOT EXISTS idx_actions_gamePk_atBatIndex ON actions(gamePk, atBatIndex);
