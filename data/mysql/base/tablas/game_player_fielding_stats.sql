USE baseball;

DROP TABLE game_player_fielding_stats;

CREATE TABLE game_player_fielding_stats (
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(10),
  playerId INTEGER,
  assists INTEGER,
  caughtStealing INTEGER,
  chances INTEGER,
  errors INTEGER,
  passedBall INTEGER,
  pickoffs INTEGER,
  putOuts INTEGER,
  stolenBases INTEGER
) ENGINE = INNODB;

ALTER TABLE game_player_fielding_stats ADD PRIMARY KEY(gamePk, teamId, playerId);
