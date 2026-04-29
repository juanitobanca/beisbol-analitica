DROP TABLE IF EXISTS game_player_positions;

-- Base: Posiciones jugadas por cada jugador en un juego (limpiado de stg_box_player_game_positions)
CREATE TABLE game_player_positions (
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  teamType TEXT,                 -- Tipo de equipo: "home" o "away"
  playerId INTEGER,              -- ID del jugador
  positionAbbrev TEXT            -- Abreviatura de la posición (ej: "P", "C", "SS", "CF")
);

CREATE INDEX IF NOT EXISTS idx_game_player_positions_gamePk_teamId_playerId ON game_player_positions(gamePk, teamId, playerId);
