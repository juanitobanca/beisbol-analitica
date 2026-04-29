DROP TABLE IF EXISTS stg_play_runner;

-- Staging: Movimientos de corredores en cada jugada (fuente: MLB Stats API play-by-play)
 CREATE TABLE IF NOT EXISTS stg_play_runner (
  endBase TEXT,                  -- Base a la que llegó el corredor (ej: "1B", "2B", "3B", "score")
  isOut INTEGER,                 -- 1 si el corredor fue puesto out
  outBase TEXT,                  -- Base donde fue puesto out
  outNumber REAL,                -- Número de out en la jugada (1, 2 o 3)
  startBase TEXT,                -- Base desde la que partió el corredor (NULL=home)
  earned INTEGER,                -- 1 si la carrera es limpia (earned run)
  event TEXT,                    -- Evento que causó el movimiento (ej: "Single", "Stolen Base")
  eventType TEXT,                -- Código del evento (ej: "single", "stolen_base")
  isScoringEvent INTEGER,        -- 1 si el corredor anotó carrera
  movementReason TEXT,           -- Razón del movimiento (ej: "r_adv_force", "r_stolen_base")
  playIndex INTEGER,             -- Índice de la jugada dentro del turno al bate
  rbi INTEGER,                   -- 1 si la carrera cuenta como RBI
  responsiblePitcherId INTEGER,  -- ID del pitcher responsable de esta carrera
  teamUnearned INTEGER,          -- 1 si la carrera es no-limpia para el equipo
  runnerId INTEGER,              -- ID del corredor
  gamePk INTEGER,                -- ID único del juego
  atBatIndex INTEGER             -- Índice del turno al bate
);
