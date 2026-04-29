DROP TABLE IF EXISTS game_officials;

-- Base: Oficiales (umpires) asignados a cada juego con su posición (limpiado de stg_box_officials)
CREATE TABLE game_officials (
  gamePk INTEGER,                -- ID único del juego
  officialId INTEGER,            -- ID del oficial (umpire)
  position TEXT                  -- Posición del oficial (ej: "Home Plate", "First Base", "Second Base", "Third Base")
);

CREATE INDEX IF NOT EXISTS idx_game_officials_gamePk ON game_officials(gamePk);
