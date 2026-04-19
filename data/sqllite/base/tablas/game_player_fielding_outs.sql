DROP TABLE IF EXISTS game_player_fielding_outs;

CREATE TABLE game_player_fielding_outs (
  gamePk INTEGER,
  teamId INTEGER,
  playerId INTEGER,
  positionAbbrev TEXT,
  outs INTEGER
);

CREATE INDEX IF NOT EXISTS idx_game_player_fielding_outs_gamePk_playerId_positionAbbrev ON game_player_fielding_outs(gamePk, playerId, positionAbbrev);
