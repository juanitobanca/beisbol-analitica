DROP TABLE IF EXISTS stg_box_player_fielding;

CREATE TABLE IF NOT EXISTS stg_box_player_fielding (
  assists REAL,
  caughtStealing REAL,
  chances REAL,
  errors REAL,
  passedBall REAL,
  pickoffs REAL,
  putOuts REAL,
  stolenBases REAL,
  gamePk INTEGER,
  teamId INTEGER,
  teamType TEXT,
  playerId INTEGER
);
