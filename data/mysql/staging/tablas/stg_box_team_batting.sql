USE baseball;

DROP TABLE stg_box_team_batting;

CREATE TABLE IF NOT EXISTS stg_box_team_batting (
  atBats INTEGER,
  baseOnBalls INTEGER,
  catchersInterference INTEGER,
  caughtStealing INTEGER,
  doubles INTEGER,
  flyOuts INTEGER,
  groundIntoDoublePlay INTEGER,
  groundIntoTriplePlay INTEGER,
  groundOuts INTEGER,
  hitByPitch INTEGER,
  hits INTEGER,
  homeRuns INTEGER,
  intentionalWalks INTEGER,
  leftOnBase INTEGER,
  pickoffs INTEGER,
  rbi INTEGER,
  runs INTEGER,
  sacBunts INTEGER,
  sacFlies INTEGER,
  stolenBases INTEGER,
  strikeOuts INTEGER,
  totalBases INTEGER,
  triples INTEGER,
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(20)
) ENGINE = INNODB;
