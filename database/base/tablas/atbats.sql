DROP TABLE IF EXISTS atbats;

CREATE TABLE atbats (
  gamePk INTEGER,
  inning INTEGER,
  halfInning TEXT,
  atBatIndex INTEGER,
  battingTeamId INTEGER,
  pitchingTeamId INTEGER,
  endOuts INTEGER,
  endBalls INTEGER,
  endStrikes INTEGER,
  batterId INTEGER,
  pitcherId INTEGER,
  hasOut INTEGER,
  hasReview INTEGER,
  isScoringPlay INTEGER,
  rbi INTEGER,
  awayScore INTEGER,
  homeScore INTEGER,
  event TEXT,
  eventType TEXT,
  batSide TEXT,
  pitchHand TEXT,
  menOnBase TEXT,
  description TEXT,
  pitches INTEGER,
  HM4 TEXT,
  HM8 TEXT,
  PRIMARY KEY(gamePk, atBatIndex)
);

CREATE INDEX IF NOT EXISTS idx_atbats_gamePk ON atbats(seasonId);
CREATE INDEX IF NOT EXISTS idx_atbats_batterId ON atbats(batterId);
CREATE INDEX IF NOT EXISTS idx_atbats_pitcherId ON atbats(pitcherId);
