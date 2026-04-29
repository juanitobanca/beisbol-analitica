DROP TABLE IF EXISTS agg_team_performance_stats;

-- Agregados: Rendimiento de equipos — victorias, derrotas, diferencial de carreras y expectativa pitagórica
CREATE TABLE agg_team_performance_stats (
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
  -- Estadísticas de rendimiento
  runs INTEGER,                          -- Carreras anotadas
  runsAllowed INTEGER,                   -- Carreras permitidas
  runDifferential INTEGER,               -- Diferencial de carreras (runs - runsAllowed)
  wins INTEGER,                          -- Victorias
  losses INTEGER,                        -- Derrotas
  -- Métricas derivadas
  winPercentage REAL,                    -- Porcentaje de victorias (W / (W + L))
  pythagoreanExpectation REAL,           -- Expectativa pitagórica (R² / (R² + RA²))
  attendance INTEGER,                    -- Asistencia acumulada
  -- Atributos de nombres (poblados por update_table_attributes)
  majorLeague TEXT,                      -- Nombre de la liga
  teamName TEXT,                         -- Nombre del equipo
  venueName TEXT                         -- Nombre del estadio
);

CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_groupingId ON agg_team_performance_stats(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_groupingDescription ON agg_team_performance_stats(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_majorLeagueId ON agg_team_performance_stats(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_seasonId ON agg_team_performance_stats(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_venueId ON agg_team_performance_stats(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_team_performance_stats_teamId ON agg_team_performance_stats(teamId);
