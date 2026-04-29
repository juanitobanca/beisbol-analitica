DROP TABLE IF EXISTS rem_event_run_value;

-- Run Expectancy: Valor en carreras de cada tipo de evento — cuántas carreras (en promedio) cambia la expectativa por evento
CREATE TABLE IF NOT EXISTS rem_event_run_value (
  majorLeagueId INTEGER,             -- ID de la liga mayor
  seasonId REAL,                     -- Año de la temporada
  venueId INTEGER,                   -- ID del estadio (NULL = todos los estadios)
  event TEXT,                        -- Tipo de evento (ej: "Single", "Home Run", "Strikeout")
  startRunExpectancy REAL,           -- Expectativa de carreras promedio al inicio del evento
  runsScoredInPlay REAL,             -- Carreras promedio anotadas durante el evento
  endRunExpectancy REAL,             -- Expectativa de carreras promedio después del evento
  events INTEGER,                    -- Número de ocurrencias del evento
  runValue REAL,                     -- Valor en carreras del evento = (carreras + RE_después) - RE_antes
  groupingId INTEGER,                -- ID del nivel de agrupación
  groupingDescription TEXT,          -- Descripción del nivel de agrupación
  majorLeague TEXT,                  -- Nombre de la liga (atributo)
  venueName TEXT                     -- Nombre del estadio (atributo)
);

CREATE INDEX IF NOT EXISTS idx_rem_event_run_value_groupingId ON rem_event_run_value(groupingId);
CREATE INDEX IF NOT EXISTS idx_rem_event_run_value_majorLeagueId ON rem_event_run_value(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_rem_event_run_value_venueId ON rem_event_run_value(venueId);
