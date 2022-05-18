USE baseball;

DROP TABLE stg_box_team_batting_order;

CREATE TABLE IF NOT EXISTS stg_box_team_batting_order (
  gamePk INTEGER,
  teamId INTEGER,
  playerId INTEGER,
  teamType VARCHAR(20),
  battingOrder INTEGER
) ENGINE = INNODB;
