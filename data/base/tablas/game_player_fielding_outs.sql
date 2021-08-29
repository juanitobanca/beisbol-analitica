USE baseball;

DROP TABLE game_player_fielding_outs;

CREATE TABLE game_player_fielding_outs (
  gamePk INTEGER,
  teamId INTEGER,
  playerId INTEGER,
  positionAbbrev VARCHAR(10),
  outs INTEGER
) ENGINE = INNODB;

ALTER TABLE game_player_fielding_outs ADD INDEX(gamePk, playerId, positionAbbrev);
