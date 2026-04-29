DROP TABLE IF EXISTS runners;

-- Base: Movimientos de corredores en cada jugada — robos, avances, outs en bases (limpiado de stg_play_runner)
CREATE TABLE runners (
  gamePk INTEGER,                        -- ID único del juego
  inning INTEGER,                        -- Número de inning
  halfInning TEXT,                       -- Mitad del inning: "top" o "bottom"
  pitchingTeamId INTEGER,                -- ID del equipo que pitchea
  battingTeamId INTEGER,                 -- ID del equipo al bate
  atBatIndex INTEGER,                    -- Índice del turno al bate
  playIndex INTEGER,                     -- Índice de la jugada dentro del turno
  event TEXT,                            -- Evento que causó el movimiento (ej: "Single", "Stolen Base")
  eventType TEXT,                        -- Código del evento (ej: "single", "stolen_base")
  isScoringPlay INTEGER,                 -- 1 si el corredor anotó carrera
  movementReason TEXT,                   -- Razón del movimiento (ej: "r_adv_force", "r_stolen_base")
  rbi INTEGER,                           -- 1 si la carrera cuenta como RBI
  responsiblePitcherId INTEGER,          -- ID del pitcher responsable de esta carrera
  runnerId INTEGER,                      -- ID del corredor
  startBase TEXT,                        -- Base desde la que partió (NULL=home)
  endBase TEXT,                          -- Base a la que llegó (ej: "1B", "2B", "3B", "score")
  isOut INTEGER,                         -- 1 si el corredor fue puesto out
  outBase TEXT,                          -- Base donde fue puesto out
  outNumber INTEGER,                     -- Número de out en la jugada (1, 2 o 3)
  earned INTEGER,                        -- 1 si la carrera es limpia (earned run)
  teamUnearned INTEGER                   -- 1 si la carrera es no-limpia para el equipo
);

CREATE INDEX IF NOT EXISTS idx_runners_gamePk ON runners(gamePk);
CREATE INDEX IF NOT EXISTS idx_runners_atBatIndex ON runners(atBatIndex);
CREATE INDEX IF NOT EXISTS idx_runners_runnerId ON runners(runnerId);

-- For Run Expectancy
CREATE INDEX IF NOT EXISTS idx_runners_game_inning_play ON runners(gamePk, inning, halfInning, atBatIndex, playIndex);
CREATE INDEX idx_runners_game_play_event_type ON runners(gamePk, atBatIndex, playIndex, event, eventType);
