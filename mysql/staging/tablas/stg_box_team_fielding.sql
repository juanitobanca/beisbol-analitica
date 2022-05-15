USE baseball;

DROP TABLE stg_box_team_fielding;

CREATE TABLE IF NOT EXISTS stg_box_team_fielding (
  assists INTEGER,
  caughtStealing INTEGER,
  chances INTEGER,
  errors INTEGER,
  passedBall INTEGER,
  pickoffs INTEGER,
  putOuts INTEGER,
  stolenBases INTEGER,
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(20)
) ENGINE = INNODB;
