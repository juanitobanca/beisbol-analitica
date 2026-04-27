DROP TABLE IF EXISTS stg_box_officials;

-- Staging: Oficiales asignados a cada juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_officials(
  gamePk INTEGER,          -- ID único del juego
  officialId INTEGER,      -- ID del oficial (umpire)
  position TEXT            -- Posición del oficial (ej: "Home Plate", "First Base")
);
