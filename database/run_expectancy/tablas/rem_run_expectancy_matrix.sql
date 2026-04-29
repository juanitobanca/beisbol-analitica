DROP TABLE IF EXISTS rem_run_expectancy_matrix;

-- Run Expectancy: Matriz de expectativa de carreras — carreras esperadas según situación de bases y outs
-- Calculada empíricamente: promedio de carreras que se anotan desde cada estado hasta el final del inning
CREATE TABLE IF NOT EXISTS rem_run_expectancy_matrix (
  groupingId INTEGER,                        -- ID del nivel de agrupación
  groupingDescription TEXT,                  -- Descripción del nivel de agrupación
  majorLeagueId INTEGER,                     -- ID de la liga mayor
  seasonId REAL,                             -- Año de la temporada
  venueId INTEGER,                           -- ID del estadio (NULL = todos los estadios)
  runnersBeforePlay TEXT,                    -- Estado de bases (ej: "___", "1B__", "1B2B_", "1B2B3B")
  zeroOutsRunsScoredEndInning INTEGER,       -- Total carreras restantes con 0 outs
  zeroOutsRunsScoredBeforePlay INTEGER,      -- Carreras acumuladas antes de jugada con 0 outs
  zeroOutsEvents INTEGER,                    -- Número de eventos con 0 outs
  zeroOutsRunExpectancy REAL,                -- Expectativa de carreras con 0 outs
  oneOutsRunsScoredEndInning INTEGER,        -- Total carreras restantes con 1 out
  oneOutsRunsScoredBeforePlay INTEGER,       -- Carreras acumuladas antes de jugada con 1 out
  oneOutsEvents INTEGER,                     -- Número de eventos con 1 out
  oneOutsRunExpectancy REAL,                 -- Expectativa de carreras con 1 out
  twoOutsRunsScoredEndInning INTEGER,        -- Total carreras restantes con 2 outs
  twoOutsRunsScoredBeforePlay INTEGER,       -- Carreras acumuladas antes de jugada con 2 outs
  twoOutsEvents INTEGER,                     -- Número de eventos con 2 outs
  twoOutsRunExpectancy REAL,                 -- Expectativa de carreras con 2 outs
  sortingOrder INTEGER,                      -- Orden de visualización
  majorLeague TEXT,                          -- Nombre de la liga (atributo)
  venueName TEXT                             -- Nombre del estadio (atributo)
);

CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_groupingId ON rem_run_expectancy_matrix(groupingId);
CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_majorLeagueId ON rem_run_expectancy_matrix(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_seasonId ON rem_run_expectancy_matrix(seasonId);
CREATE INDEX IF NOT EXISTS idx_rem_run_expectancy_matrix_venueId ON rem_run_expectancy_matrix(venueId);
