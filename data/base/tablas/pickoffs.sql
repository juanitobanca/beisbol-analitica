DROP TABLE IF EXISTS pickoffs;

CREATE TABLE pickoffs (
  gamePk INTEGER,
  atBatIndex INTEGER,
  playIndex INTEGER,
  outs INTEGER,
  balls INTEGER,
  strikes INTEGER,
  fromCatcher INTEGER,
  hasReview INTEGER,
  baseCode INTEGER
);

CREATE INDEX IF NOT EXISTS idx_pickoffs_gamePk_atBatIndex ON pickoffs(gamePk, atBatIndex);
