USE baseball;

DROP TABLE stg_box_player_fielding;

CREATE TABLE IF NOT EXISTS stg_box_player_fielding (
  assists DOUBLE,
  caughtStealing DOUBLE,
  chances DOUBLE,
  errors DOUBLE,
  passedBall DOUBLE,
  pickoffs DOUBLE,
  putOuts DOUBLE,
  stolenBases DOUBLE,
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(20),
  playerId INTEGER
) ENGINE = INNODB;
