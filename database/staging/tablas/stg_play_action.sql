DROP TABLE IF EXISTS stg_play_action;

-- Staging: Acciones del juego no relacionadas a pitcheos (sustituciones, revisiones, etc.) (fuente: MLB Stats API play-by-play)
CREATE TABLE IF NOT EXISTS stg_play_action (
  description TEXT,        -- Descripción narrativa de la acción
  event TEXT,              -- Tipo de evento (ej: "Pitching Substitution", "Defensive Switch")
  awayScore INTEGER,       -- Marcador visitante al momento de la acción
  homeScore INTEGER,       -- Marcador local al momento de la acción
  isScoringPlay INTEGER,   -- 1 si la acción resultó en carrera
  hasReview INTEGER,       -- 1 si hubo revisión de video
  eventType TEXT,          -- Código del evento (ej: "pitching_substitution")
  balls INTEGER,           -- Conteo de bolas al momento de la acción
  strikes INTEGER,         -- Conteo de strikes al momento de la acción
  outs INTEGER,            -- Conteo de outs al momento de la acción
  playerId INTEGER,        -- ID del jugador involucrado
  abbreviation TEXT,       -- Abreviatura de la posición del jugador
  code TEXT,               -- Código de la posición
  name TEXT,               -- Nombre de la posición
  atBatIndex INTEGER,      -- Índice del turno al bate
  gamePk INTEGER,          -- ID único del juego
  `index` INTEGER,         -- Índice secuencial de la acción
  startTime TEXT,          -- Timestamp de inicio (ISO 8601)
  endTime TEXT,            -- Timestamp de fin (ISO 8601)
  isPitch INTEGER,         -- 0 ya que no es un pitcheo
  type TEXT,               -- Tipo: "action"
  battingOrder TEXT,       -- Posición en el orden de bateo (para sustituciones)
  injuryType TEXT          -- Tipo de lesión (si aplica)
);
