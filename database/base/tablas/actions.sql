DROP TABLE IF EXISTS actions;

-- Base: Acciones del juego no relacionadas a pitcheos — sustituciones, revisiones, lesiones, etc. (limpiado de stg_play_action)
CREATE TABLE actions (
  gamePk INTEGER,                -- ID único del juego
  inning INTEGER,                -- Número de inning
  halfInning TEXT,               -- Mitad del inning: "top" o "bottom"
  pitchingTeamId INTEGER,        -- ID del equipo que pitchea
  battingTeamId INTEGER,         -- ID del equipo al bate
  atBatIndex INTEGER,            -- Índice del turno al bate
  playIndex INTEGER,             -- Índice secuencial de la acción dentro del turno
  playerId INTEGER,              -- ID del jugador involucrado
  endOuts INTEGER,               -- Outs al final de la acción
  endBalls INTEGER,              -- Bolas al final de la acción
  endStrikes INTEGER,            -- Strikes al final de la acción
  hasReview INTEGER,             -- 1 si hubo revisión de video
  isScoringPlay INTEGER,         -- 1 si la acción resultó en carrera
  awayScore INTEGER,             -- Marcador visitante al momento de la acción
  homeScore INTEGER,             -- Marcador local al momento de la acción
  event TEXT,                    -- Tipo de evento (ej: "Pitching Substitution", "Defensive Switch")
  eventType TEXT,                -- Código del evento (ej: "pitching_substitution")
  battingOrder INTEGER,          -- Posición en el orden de bateo (para sustituciones)
  positionAbbrev TEXT,           -- Abreviatura de la posición del jugador (ej: "P", "SS")
  injuryType TEXT,               -- Tipo de lesión (si aplica)
  description TEXT               -- Descripción narrativa de la acción
);

CREATE INDEX IF NOT EXISTS idx_actions_gamePk_atBatIndex ON actions(gamePk, atBatIndex);
