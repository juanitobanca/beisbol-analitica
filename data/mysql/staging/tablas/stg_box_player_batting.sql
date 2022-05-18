USE baseball;

DROP TABLE stg_box_player_batting;

CREATE TABLE stg_box_player_batting (
  atBats DOUBLE,
  baseOnBalls DOUBLE,
  catchersInterference DOUBLE,
  caughtStealing DOUBLE,
  doubles DOUBLE,
  flyOuts DOUBLE,
  groundIntoDoublePlay DOUBLE,
  groundIntoTriplePlay DOUBLE,
  groundOuts DOUBLE,
  hitByPitch DOUBLE,
  hits DOUBLE,
  homeRuns DOUBLE,
  intentionalWalks DOUBLE,
  leftOnBase DOUBLE,
  pickoffs DOUBLE,
  rbi DOUBLE,
  runs DOUBLE,
  sacBunts DOUBLE,
  sacFlies DOUBLE,
  stolenBases DOUBLE,
  strikeOuts DOUBLE,
  totalBases DOUBLE,
  triples DOUBLE,
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(30),
  playerId INTEGER
) ENGINE = INNODB;
