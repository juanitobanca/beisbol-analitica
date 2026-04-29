DROP TABLE IF EXISTS agg_fielding_stats;

-- Agregados: Estadísticas de fildeo agregadas con métricas derivadas (FLD%, RF/9, RF/G)
CREATE TABLE agg_fielding_stats (
  -- Dimensiones de agrupación
  groupingId INTEGER,                    -- ID del nivel de agrupación (OLAP cube)
  groupingDescription TEXT,              -- Descripción del nivel de agrupación
  aggregationType TEXT,                  -- Tipo de agregación: "SUM", "AVG", etc.
  majorLeagueId INTEGER,                 -- ID de la liga mayor
  seasonId INTEGER,                      -- Año de la temporada
  gameDate TEXT,                         -- Fecha del juego (si aplica)
  gameType2 TEXT,                        -- Tipo de juego: "RS", "PS"
  teamType TEXT,                         -- Tipo de equipo: "home" o "away"
  venueId INTEGER,                       -- ID del estadio
  teamId INTEGER,                        -- ID del equipo
  positionAbbrev TEXT,                   -- Abreviatura de la posición (ej: "SS", "1B", "CF")
  playerId INTEGER,                      -- ID del jugador
  -- Estadísticas de fildeo
  assists INTEGER,                       -- Asistencias (A)
  catcherInterferences INTEGER,          -- Interferencias del catcher
  errors INTEGER,                        -- Errores (E)
  games INTEGER,                         -- Juegos jugados
  putOuts INTEGER,                       -- Outs directos (PO)
  totalChances INTEGER,                  -- Oportunidades totales (TC = A + PO + E)
  outsPlayed INTEGER,                    -- Outs jugados en la posición
  inningsPlayed REAL,                    -- Innings jugados en la posición
  -- Métricas derivadas
  gamesPlayed REAL,                      -- Juegos jugados (equivalente)
  fieldingPercentage REAL,               -- Porcentaje de fildeo (FLD% = (A + PO) / TC)
  rangeFactorPerInning REAL,             -- Range Factor por inning (RF/9 = (A + PO) * 9 / IP)
  rangeFactorPerGame REAL,               -- Range Factor por juego (RF/G = (A + PO) / G)
  -- Atributos de nombres (poblados por update_table_attributes)
  majorLeague TEXT,                      -- Nombre de la liga
  playerName TEXT,                       -- Nombre del jugador
  teamName TEXT,                         -- Nombre del equipo
  venueName TEXT                         -- Nombre del estadio
);

CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_groupingId ON agg_fielding_stats(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_majorLeagueId ON agg_fielding_stats(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_seasonId ON agg_fielding_stats(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_venueId ON agg_fielding_stats(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_teamId ON agg_fielding_stats(teamId);
CREATE INDEX IF NOT EXISTS idx_agg_fielding_stats_playerId ON agg_fielding_stats(playerId);
