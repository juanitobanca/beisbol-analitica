DROP TABLE IF EXISTS game_player_fielding_outs;

-- Base: Outs registrados por jugador y posición por juego (derivado de jugada por jugada)
CREATE TABLE game_player_fielding_outs (
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  playerId INTEGER,              -- ID del jugador
  positionAbbrev TEXT,           -- Abreviatura de la posición (ej: "SS", "1B", "P")
  outs INTEGER                   -- Número de outs registrados en esa posición
);

CREATE INDEX IF NOT EXISTS idx_game_player_fielding_outs_gamePk_playerId_positionAbbrev ON game_player_fielding_outs(gamePk, playerId, positionAbbrev);
