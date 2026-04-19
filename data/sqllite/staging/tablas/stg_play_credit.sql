DROP TABLE IF EXISTS stg_play_credit;

CREATE TABLE IF NOT EXISTS stg_play_credit (
  credit TEXT,
  playerId INTEGER,
  abbreviation TEXT,
  code TEXT,
  name TEXT,
  type TEXT,
  gamePk INTEGER,
  atBatIndex INTEGER
);
