DROP TABLE IF EXISTS stg_play_credit;

-- Staging: Créditos de fildeo por jugada (quién participó en cada out) (fuente: MLB Stats API play-by-play)
CREATE TABLE IF NOT EXISTS stg_play_credit (
  credit TEXT,             -- Tipo de crédito: "f_assist" (asistencia), "f_putout" (out directo), "f_fielded_ball"
  playerId INTEGER,        -- ID del fildeador
  abbreviation TEXT,       -- Abreviatura de la posición (ej: "SS", "1B")
  code TEXT,               -- Código numérico de la posición
  name TEXT,               -- Nombre de la posición
  type TEXT,               -- Tipo de posición
  gamePk INTEGER,          -- ID único del juego
  atBatIndex INTEGER       -- Índice del turno al bate
);
