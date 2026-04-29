DROP TABLE IF EXISTS pf_heat_map_park_factors;

-- Park Factors: Factores de estadio por zona del campo (heat map) — mide cómo el estadio afecta la distribución de batazos
-- Sufijos: _SH=scored home, _SA=scored away, _AH=allowed home, _AA=allowed away, _PF=park factor calculado
-- Zonas HM4 (4 cuadrantes): RF1, RF2, LF1, LF2, FHP, FLF, FRF
-- Zonas HM8 (8 octantes): RF1-RF4, LF1-LF4
-- Métricas por zona: HR=jonrones, H=hits totales
CREATE TABLE pf_heat_map_park_factors (
  groupingId INTEGER,                    -- ID del nivel de agrupación
  groupingDescription TEXT,              -- Descripción del nivel de agrupación
  majorLeagueId INTEGER,                 -- ID de la liga mayor
  seasonId INTEGER,                      -- Año de la temporada
  venueId INTEGER,                       -- ID del estadio
  teamId INTEGER,                        -- ID del equipo local
  homeGames INTEGER,                     -- Juegos como local
  awayGames INTEGER,                     -- Juegos como visitante
  -- HM4: Scored Home (bateo como local)
  HM4_FHP_SH INTEGER,                   -- Fouls home plate — bateo local
  HM4_FLF_SH INTEGER,                   -- Fouls left field — bateo local
  HM4_FRF_SH INTEGER,                   -- Fouls right field — bateo local
  HM4_LF1_HR_SH INTEGER,                -- Jonrones en LF1 — bateo local
  HM4_LF1_H_SH INTEGER,                 -- Hits en LF1 — bateo local
  HM4_LF2_HR_SH INTEGER,                -- Jonrones en LF2 — bateo local
  HM4_LF2_H_SH INTEGER,                 -- Hits en LF2 — bateo local
  HM4_RF1_HR_SH INTEGER,                -- Jonrones en RF1 — bateo local
  HM4_RF1_H_SH INTEGER,                 -- Hits en RF1 — bateo local
  HM4_RF2_HR_SH INTEGER,                -- Jonrones en RF2 — bateo local
  HM4_RF2_H_SH INTEGER,                 -- Hits en RF2 — bateo local
  -- HM8: Scored Home
  HM8_LF1_HR_SH INTEGER,                -- Jonrones en LF1 (8 oct) — bateo local
  HM8_LF1_H_SH INTEGER,                 -- Hits en LF1 (8 oct) — bateo local
  HM8_LF2_HR_SH INTEGER,                -- Jonrones en LF2 (8 oct) — bateo local
  HM8_LF2_H_SH INTEGER,                 -- Hits en LF2 (8 oct) — bateo local
  HM8_LF3_HR_SH INTEGER,                -- Jonrones en LF3 (8 oct) — bateo local
  HM8_LF3_H_SH INTEGER,                 -- Hits en LF3 (8 oct) — bateo local
  HM8_LF4_HR_SH INTEGER,                -- Jonrones en LF4 (8 oct) — bateo local
  HM8_LF4_H_SH INTEGER,                 -- Hits en LF4 (8 oct) — bateo local
  HM8_RF1_HR_SH INTEGER,                -- Jonrones en RF1 (8 oct) — bateo local
  HM8_RF1_H_SH INTEGER,                 -- Hits en RF1 (8 oct) — bateo local
  HM8_RF2_HR_SH INTEGER,                -- Jonrones en RF2 (8 oct) — bateo local
  HM8_RF2_H_SH INTEGER,                 -- Hits en RF2 (8 oct) — bateo local
  HM8_RF3_HR_SH INTEGER,                -- Jonrones en RF3 (8 oct) — bateo local
  HM8_RF3_H_SH INTEGER,                 -- Hits en RF3 (8 oct) — bateo local
  HM8_RF4_HR_SH INTEGER,                -- Jonrones en RF4 (8 oct) — bateo local
  HM8_RF4_H_SH INTEGER,                 -- Hits en RF4 (8 oct) — bateo local
  -- HM4: Scored Away (bateo como visitante)
  HM4_FHP_SA INTEGER,                   -- Fouls home plate — bateo visitante
  HM4_FLF_SA INTEGER,                   -- Fouls left field — bateo visitante
  HM4_FRF_SA INTEGER,                   -- Fouls right field — bateo visitante
  HM4_LF1_HR_SA INTEGER,                -- Jonrones en LF1 — bateo visitante
  HM4_LF1_H_SA INTEGER,                 -- Hits en LF1 — bateo visitante
  HM4_LF2_HR_SA INTEGER,                -- Jonrones en LF2 — bateo visitante
  HM4_LF2_H_SA INTEGER,                 -- Hits en LF2 — bateo visitante
  HM4_RF1_HR_SA INTEGER,                -- Jonrones en RF1 — bateo visitante
  HM4_RF1_H_SA INTEGER,                 -- Hits en RF1 — bateo visitante
  HM4_RF2_HR_SA INTEGER,                -- Jonrones en RF2 — bateo visitante
  HM4_RF2_H_SA INTEGER,                 -- Hits en RF2 — bateo visitante
  -- HM8: Scored Away
  HM8_LF1_HR_SA INTEGER,                -- Jonrones en LF1 (8 oct) — bateo visitante
  HM8_LF1_H_SA INTEGER,                 -- Hits en LF1 (8 oct) — bateo visitante
  HM8_LF2_HR_SA INTEGER,                -- Jonrones en LF2 (8 oct) — bateo visitante
  HM8_LF2_H_SA INTEGER,                 -- Hits en LF2 (8 oct) — bateo visitante
  HM8_LF3_HR_SA INTEGER,                -- Jonrones en LF3 (8 oct) — bateo visitante
  HM8_LF3_H_SA INTEGER,                 -- Hits en LF3 (8 oct) — bateo visitante
  HM8_LF4_HR_SA INTEGER,                -- Jonrones en LF4 (8 oct) — bateo visitante
  HM8_LF4_H_SA INTEGER,                 -- Hits en LF4 (8 oct) — bateo visitante
  HM8_RF1_HR_SA INTEGER,                -- Jonrones en RF1 (8 oct) — bateo visitante
  HM8_RF1_H_SA INTEGER,                 -- Hits en RF1 (8 oct) — bateo visitante
  HM8_RF2_HR_SA INTEGER,                -- Jonrones en RF2 (8 oct) — bateo visitante
  HM8_RF2_H_SA INTEGER,                 -- Hits en RF2 (8 oct) — bateo visitante
  HM8_RF3_HR_SA INTEGER,                -- Jonrones en RF3 (8 oct) — bateo visitante
  HM8_RF3_H_SA INTEGER,                 -- Hits en RF3 (8 oct) — bateo visitante
  HM8_RF4_HR_SA INTEGER,                -- Jonrones en RF4 (8 oct) — bateo visitante
  HM8_RF4_H_SA INTEGER,                 -- Hits en RF4 (8 oct) — bateo visitante
  -- HM4: Allowed Home (pitcheo como local)
  HM4_FHP_AH INTEGER,                   -- Fouls home plate — pitcheo local
  HM4_FLF_AH INTEGER,                   -- Fouls left field — pitcheo local
  HM4_FRF_AH INTEGER,                   -- Fouls right field — pitcheo local
  HM4_LF1_HR_AH INTEGER,                -- Jonrones en LF1 — pitcheo local
  HM4_LF1_H_AH INTEGER,                 -- Hits en LF1 — pitcheo local
  HM4_LF2_HR_AH INTEGER,                -- Jonrones en LF2 — pitcheo local
  HM4_LF2_H_AH INTEGER,                 -- Hits en LF2 — pitcheo local
  HM4_RF1_HR_AH INTEGER,                -- Jonrones en RF1 — pitcheo local
  HM4_RF1_H_AH INTEGER,                 -- Hits en RF1 — pitcheo local
  HM4_RF2_HR_AH INTEGER,                -- Jonrones en RF2 — pitcheo local
  HM4_RF2_H_AH INTEGER,                 -- Hits en RF2 — pitcheo local
  -- HM8: Allowed Home
  HM8_LF1_HR_AH INTEGER,                -- Jonrones en LF1 (8 oct) — pitcheo local
  HM8_LF1_H_AH INTEGER,                 -- Hits en LF1 (8 oct) — pitcheo local
  HM8_LF2_HR_AH INTEGER,                -- Jonrones en LF2 (8 oct) — pitcheo local
  HM8_LF2_H_AH INTEGER,                 -- Hits en LF2 (8 oct) — pitcheo local
  HM8_LF3_HR_AH INTEGER,                -- Jonrones en LF3 (8 oct) — pitcheo local
  HM8_LF3_H_AH INTEGER,                 -- Hits en LF3 (8 oct) — pitcheo local
  HM8_LF4_HR_AH INTEGER,                -- Jonrones en LF4 (8 oct) — pitcheo local
  HM8_LF4_H_AH INTEGER,                 -- Hits en LF4 (8 oct) — pitcheo local
  HM8_RF1_HR_AH INTEGER,                -- Jonrones en RF1 (8 oct) — pitcheo local
  HM8_RF1_H_AH INTEGER,                 -- Hits en RF1 (8 oct) — pitcheo local
  HM8_RF2_HR_AH INTEGER,                -- Jonrones en RF2 (8 oct) — pitcheo local
  HM8_RF2_H_AH INTEGER,                 -- Hits en RF2 (8 oct) — pitcheo local
  HM8_RF3_HR_AH INTEGER,                -- Jonrones en RF3 (8 oct) — pitcheo local
  HM8_RF3_H_AH INTEGER,                 -- Hits en RF3 (8 oct) — pitcheo local
  HM8_RF4_HR_AH INTEGER,                -- Jonrones en RF4 (8 oct) — pitcheo local
  HM8_RF4_H_AH INTEGER,                 -- Hits en RF4 (8 oct) — pitcheo local
  -- HM4: Allowed Away (pitcheo como visitante)
  HM4_FHP_AA INTEGER,                   -- Fouls home plate — pitcheo visitante
  HM4_FLF_AA INTEGER,                   -- Fouls left field — pitcheo visitante
  HM4_FRF_AA INTEGER,                   -- Fouls right field — pitcheo visitante
  HM4_LF1_HR_AA INTEGER,                -- Jonrones en LF1 — pitcheo visitante
  HM4_LF1_H_AA INTEGER,                 -- Hits en LF1 — pitcheo visitante
  HM4_LF2_HR_AA INTEGER,                -- Jonrones en LF2 — pitcheo visitante
  HM4_LF2_H_AA INTEGER,                 -- Hits en LF2 — pitcheo visitante
  HM4_RF1_HR_AA INTEGER,                -- Jonrones en RF1 — pitcheo visitante
  HM4_RF1_H_AA INTEGER,                 -- Hits en RF1 — pitcheo visitante
  HM4_RF2_HR_AA INTEGER,                -- Jonrones en RF2 — pitcheo visitante
  HM4_RF2_H_AA INTEGER,                 -- Hits en RF2 — pitcheo visitante
  -- HM8: Allowed Away
  HM8_LF1_HR_AA INTEGER,                -- Jonrones en LF1 (8 oct) — pitcheo visitante
  HM8_LF1_H_AA INTEGER,                 -- Hits en LF1 (8 oct) — pitcheo visitante
  HM8_LF2_HR_AA INTEGER,                -- Jonrones en LF2 (8 oct) — pitcheo visitante
  HM8_LF2_H_AA INTEGER,                 -- Hits en LF2 (8 oct) — pitcheo visitante
  HM8_LF3_HR_AA INTEGER,                -- Jonrones en LF3 (8 oct) — pitcheo visitante
  HM8_LF3_H_AA INTEGER,                 -- Hits en LF3 (8 oct) — pitcheo visitante
  HM8_LF4_HR_AA INTEGER,                -- Jonrones en LF4 (8 oct) — pitcheo visitante
  HM8_LF4_H_AA INTEGER,                 -- Hits en LF4 (8 oct) — pitcheo visitante
  HM8_RF1_HR_AA INTEGER,                -- Jonrones en RF1 (8 oct) — pitcheo visitante
  HM8_RF1_H_AA INTEGER,                 -- Hits en RF1 (8 oct) — pitcheo visitante
  HM8_RF2_HR_AA INTEGER,                -- Jonrones en RF2 (8 oct) — pitcheo visitante
  HM8_RF2_H_AA INTEGER,                 -- Hits en RF2 (8 oct) — pitcheo visitante
  HM8_RF3_HR_AA INTEGER,                -- Jonrones en RF3 (8 oct) — pitcheo visitante
  HM8_RF3_H_AA INTEGER,                 -- Hits en RF3 (8 oct) — pitcheo visitante
  HM8_RF4_HR_AA INTEGER,                -- Jonrones en RF4 (8 oct) — pitcheo visitante
  HM8_RF4_H_AA INTEGER,                 -- Hits en RF4 (8 oct) — pitcheo visitante
  -- HM4: Park Factors calculados
  HM4_FHP_PF REAL,                      -- Park factor de fouls en home plate
  HM4_FLF_PF REAL,                      -- Park factor de fouls en left field
  HM4_FRF_PF REAL,                      -- Park factor de fouls en right field
  HM4_LF1_HR_PF REAL,                   -- Park factor de jonrones en LF1
  HM4_LF1_H_PF REAL,                    -- Park factor de hits en LF1
  HM4_LF2_HR_PF REAL,                   -- Park factor de jonrones en LF2
  HM4_LF2_H_PF REAL,                    -- Park factor de hits en LF2
  HM4_RF1_HR_PF REAL,                   -- Park factor de jonrones en RF1
  HM4_RF1_H_PF REAL,                    -- Park factor de hits en RF1
  HM4_RF2_HR_PF REAL,                   -- Park factor de jonrones en RF2
  HM4_RF2_H_PF REAL,                    -- Park factor de hits en RF2
  -- HM8: Park Factors calculados
  HM8_LF1_HR_PF REAL,                   -- Park factor de jonrones en LF1 (8 oct)
  HM8_LF1_H_PF REAL,                    -- Park factor de hits en LF1 (8 oct)
  HM8_LF2_HR_PF REAL,                   -- Park factor de jonrones en LF2 (8 oct)
  HM8_LF2_H_PF REAL,                    -- Park factor de hits en LF2 (8 oct)
  HM8_LF3_HR_PF REAL,                   -- Park factor de jonrones en LF3 (8 oct)
  HM8_LF3_H_PF REAL,                    -- Park factor de hits en LF3 (8 oct)
  HM8_LF4_HR_PF REAL,                   -- Park factor de jonrones en LF4 (8 oct)
  HM8_LF4_H_PF REAL,                    -- Park factor de hits en LF4 (8 oct)
  HM8_RF1_HR_PF REAL,                   -- Park factor de jonrones en RF1 (8 oct)
  HM8_RF1_H_PF REAL,                    -- Park factor de hits en RF1 (8 oct)
  HM8_RF2_HR_PF REAL,                   -- Park factor de jonrones en RF2 (8 oct)
  HM8_RF2_H_PF REAL,                    -- Park factor de hits en RF2 (8 oct)
  HM8_RF3_HR_PF REAL,                   -- Park factor de jonrones en RF3 (8 oct)
  HM8_RF3_H_PF REAL,                    -- Park factor de hits en RF3 (8 oct)
  HM8_RF4_HR_PF REAL,                   -- Park factor de jonrones en RF4 (8 oct)
  HM8_RF4_H_PF REAL,                    -- Park factor de hits en RF4 (8 oct)
  -- Atributos
  majorLeague TEXT,                      -- Nombre de la liga (atributo)
  venueName TEXT                         -- Nombre del estadio (atributo)
);

CREATE INDEX IF NOT EXISTS idx_pf_heat_map_park_factors_groupingId ON pf_heat_map_park_factors(groupingId);
CREATE INDEX IF NOT EXISTS idx_pf_heat_map_park_factors_groupingDescription ON pf_heat_map_park_factors(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_pf_heat_map_park_factors_majorLeagueId ON pf_heat_map_park_factors(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_pf_heat_map_park_factors_seasonId ON pf_heat_map_park_factors(seasonId);
CREATE INDEX IF NOT EXISTS idx_pf_heat_map_park_factors_venueId ON pf_heat_map_park_factors(venueId);
