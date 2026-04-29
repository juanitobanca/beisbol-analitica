DROP TABLE IF EXISTS stg_play_atbat;

-- Staging: Eventos de turno al bate jugada por jugada (fuente: MLB Stats API play-by-play)
CREATE TABLE IF NOT EXISTS stg_play_atbat (
  atBatIndex INTEGER,              -- Índice secuencial del turno al bate en el juego
  captivatingIndex INTEGER,        -- Índice de emoción del turno (0-100)
  endTime TEXT,                    -- Timestamp de fin del turno (ISO 8601)
  halfInning TEXT,                 -- Mitad del inning: "top" o "bottom"
  hasOut INTEGER,                  -- 1 si hubo al menos un out en la jugada
  hasReview INTEGER,               -- 1 si hubo revisión de video
  inning INTEGER,                  -- Número de inning
  isComplete INTEGER,              -- 1 si el turno al bate terminó
  isScoringPlay INTEGER,           -- 1 si se anotó al menos una carrera
  startTime TEXT,                  -- Timestamp de inicio del turno (ISO 8601)
  awayScore INTEGER,               -- Marcador del equipo visitante después de la jugada
  description TEXT,                -- Descripción narrativa de la jugada
  event TEXT,                      -- Resultado del turno (ej: "Single", "Strikeout", "Home Run")
  eventType TEXT,                  -- Código del evento (ej: "single", "strikeout", "home_run")
  homeScore INTEGER,               -- Marcador del equipo local después de la jugada
  rbi INTEGER,                     -- Carreras impulsadas en este turno
  type TEXT,                       -- Tipo de jugada (ej: "atBat", "action")
  balls INTEGER,                   -- Conteo de bolas al final del turno
  outs INTEGER,                    -- Conteo de outs al final del turno
  strikes INTEGER,                 -- Conteo de strikes al final del turno
  batterSideCode TEXT,             -- Lado de bateo: "L" (izquierdo) o "R" (derecho)
  batterSideDescription TEXT,      -- Descripción del lado de bateo
  pitcherHandCode TEXT,            -- Mano del pitcher: "L" o "R"
  pitcherHandDescription TEXT,     -- Descripción de la mano del pitcher
  pitcherId INTEGER,               -- ID del pitcher
  batterId INTEGER,                -- ID del bateador
  menOnBase TEXT,                  -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  gamePk INTEGER                   -- ID único del juego
);
