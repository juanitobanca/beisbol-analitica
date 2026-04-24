DROP TABLE IF EXISTS stg_box_player_game_positions;

CREATE TABLE IF NOT EXISTS stg_box_player_game_positions (
  code TEXT,
  name TEXT,
  type TEXT,
  abbreviation TEXT,
  gamePk INTEGER,
  teamId INTEGER,
  teamType TEXT,
  playerId INTEGER
);
