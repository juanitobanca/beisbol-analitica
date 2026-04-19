DROP TABLE IF EXISTS game_player_positions;

CREATE TABLE game_player_positions (
  gamePk INTEGER,
  teamId INTEGER,
  teamType TEXT,
  playerId INTEGER,
  positionAbbrev TEXT
);

CREATE INDEX IF NOT EXISTS idx_game_player_positions_gamePk_teamId_playerId ON game_player_positions(gamePk, teamId, playerId);
