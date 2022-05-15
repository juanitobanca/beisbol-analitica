USE baseball;

DROP TABLE stg_box_player_game_info;

CREATE TABLE IF NOT EXISTS stg_box_player_game_info (
  isSubstitute TINYINT,
  isOnBench TINYINT,
  isCurrentPitcher TINYINT,
  isCurrentBatter TINYINT,
  fullName VARCHAR(100),
  link VARCHAR(100),
  abbreviation VARCHAR(100),
  code VARCHAR(100),
  name VARCHAR(100),
  type VARCHAR(100),
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(20),
  playerId INTEGER
) ENGINE = INNODB;
