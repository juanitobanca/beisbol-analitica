DROP TABLE IF EXISTS we_win_expectancy;

-- Win Expectancy: Probabilidad de ganar según el estado del juego
-- Calculada empíricamente: de todos los juegos con este estado, ¿en qué % ganó el equipo al bate?
-- Permite calcular WPA (Win Probability Added) por jugada
CREATE TABLE IF NOT EXISTS we_win_expectancy (
  groupingId INTEGER,              -- ID del nivel de agrupación
  groupingDescription TEXT,        -- Descripción del nivel de agrupación
  majorLeagueId INTEGER,           -- ID de la liga
  seasonId INTEGER,                -- Año de la temporada
  gameType2 TEXT,                  -- Tipo de juego: "RS", "PS", etc.
  -- Estado del juego
  inning INTEGER,                  -- Número de inning
  menOnBase TEXT,                  -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  outs INTEGER,                    -- Número de outs (0, 1 o 2)
  score TEXT,                      -- Diferencial de marcador (ej: "-2", "0", "+3")
  -- Resultados observados
  games INTEGER,                   -- Juegos con este estado exacto
  wins INTEGER,                    -- Victorias del equipo al bate
  losses INTEGER,                  -- Derrotas del equipo al bate
  winExpectancy REAL               -- Probabilidad de ganar (0.0 a 1.0)
);

CREATE INDEX IF NOT EXISTS idx_we_win_expectancy_groupingId ON we_win_expectancy(groupingId);
CREATE INDEX IF NOT EXISTS idx_we_win_expectancy_majorLeagueId ON we_win_expectancy(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_we_win_expectancy_seasonId ON we_win_expectancy(seasonId);
