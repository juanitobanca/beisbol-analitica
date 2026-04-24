DROP TABLE IF EXISTS stg_play_pickoff;

CREATE TABLE IF NOT EXISTS stg_play_pickoff (
  description TEXT,
  code TEXT,
  hasReview INTEGER,
  fromCatcher INTEGER,
  balls TEXT,
  strikes TEXT,
  outs TEXT,
  atBatIndex INTEGER,
  gamePk INTEGER,
  `index` INTEGER,
  playId TEXT,
  isPitch INTEGER
);
