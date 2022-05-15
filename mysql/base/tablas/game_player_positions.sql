USE baseball;

DROP TABLE game_player_positions;

CREATE TABLE game_player_positions (
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(10),
  playerId INTEGER,
  positionAbbrev VARCHAR(10)
) ENGINE = INNODB;

ALTER TABLE game_player_positions ADD INDEX(gamePk, teamId, playerId);
