DROP TABLE IF EXISTS stg_box_player_game_info;

CREATE TABLE IF NOT EXISTS stg_box_player_game_info (
  isSubstitute INTEGER,
  isOnBench INTEGER,
  isCurrentPitcher INTEGER,
  isCurrentBatter INTEGER,
  fullName TEXT,
  link TEXT,
  abbreviation TEXT,
  code TEXT,
  name TEXT,
  type TEXT,
  gamePk INTEGER,
  teamId INTEGER,
  teamType TEXT,
  playerId INTEGER
);
