USE baseball;

DROP TABLE game_batting_orders;

CREATE TABLE game_batting_orders (
  gamePk INTEGER,
  teamId INTEGER,
  playerId INTEGER,
  battingOrder INTEGER
) ENGINE = INNODB;

ALTER TABLE game_batting_orders ADD PRIMARY KEY(gamePk, teamId, playerId);
