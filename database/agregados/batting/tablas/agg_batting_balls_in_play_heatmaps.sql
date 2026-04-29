DROP TABLE IF EXISTS agg_batting_balls_in_play_heatmaps;

-- Agregados: Heat maps de pelotas en juego de bateo — distribución agregada de batazos por zona del campo
-- Zonas HM4 (4 cuadrantes) y HM8 (8 octantes): RF=right field, LF=left field
-- Métricas por zona: conteos totales, hits (X1B, X2B, X3B, HR, H) y trayectorias (FB, GB, LD, PU, GBNT, PUB, LDB)
CREATE TABLE agg_batting_balls_in_play_heatmaps (
  -- Dimensiones
  groupingId INTEGER,                    -- ID del nivel de agrupación (OLAP cube)
  groupingDescription TEXT,              -- Descripción del nivel de agrupación
  majorLeagueId INTEGER,                 -- ID de la liga mayor
  seasonId INTEGER,                      -- Año de la temporada
  gameDate TEXT,                         -- Fecha del juego (si aplica)
  gameType2 TEXT,                        -- Tipo de juego: "RS", "PS"
  teamType TEXT,                         -- Tipo de equipo: "home" o "away"
  venueId INTEGER,                       -- ID del estadio
  teamId INTEGER,                        -- ID del equipo
  playerId INTEGER,                      -- ID del jugador
  batSide TEXT,                          -- Lado de bateo: "L", "R" o "S"
  pitchHand TEXT,                        -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                        -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  games INTEGER,                         -- Juegos jugados
  -- HM4: Heat map en 4 cuadrantes
  HM4_RF1 INTEGER,                      -- Pelotas en juego en RF1 (right field cercano)
  HM4_RF2 INTEGER,                      -- Pelotas en juego en RF2 (right field lejano)
  HM4_LF1 INTEGER,                      -- Pelotas en juego en LF1 (left field cercano)
  HM4_LF2 INTEGER,                      -- Pelotas en juego en LF2 (left field lejano)
  HM4_FHP INTEGER,                      -- Fouls cerca de home plate
  HM4_FLF INTEGER,                      -- Fouls hacia left field
  HM4_FRF INTEGER,                      -- Fouls hacia right field
  HM4_LF1_X1B INTEGER,                  -- Sencillos en LF1
  HM4_LF1_X2B INTEGER,                  -- Dobles en LF1
  HM4_LF1_X3B INTEGER,                  -- Triples en LF1
  HM4_LF1_HR INTEGER,                   -- Jonrones en LF1
  HM4_LF1_H INTEGER,                    -- Hits totales en LF1
  HM4_LF2_X1B INTEGER,                  -- Sencillos en LF2
  HM4_LF2_X2B INTEGER,                  -- Dobles en LF2
  HM4_LF2_X3B INTEGER,                  -- Triples en LF2
  HM4_LF2_HR INTEGER,                   -- Jonrones en LF2
  HM4_LF2_H INTEGER,                    -- Hits totales en LF2
  HM4_RF1_X1B INTEGER,                  -- Sencillos en RF1
  HM4_RF1_X2B INTEGER,                  -- Dobles en RF1
  HM4_RF1_X3B INTEGER,                  -- Triples en RF1
  HM4_RF1_HR INTEGER,                   -- Jonrones en RF1
  HM4_RF1_H INTEGER,                    -- Hits totales en RF1
  HM4_RF2_X1B INTEGER,                  -- Sencillos en RF2
  HM4_RF2_X2B INTEGER,                  -- Dobles en RF2
  HM4_RF2_X3B INTEGER,                  -- Triples en RF2
  HM4_RF2_HR INTEGER,                   -- Jonrones en RF2
  HM4_RF2_H INTEGER,                    -- Hits totales en RF2
  HM4_RF1_FB INTEGER,                   -- Fly balls en RF1
  HM4_RF1_GB INTEGER,                   -- Ground balls en RF1
  HM4_RF1_LD INTEGER,                   -- Line drives en RF1
  HM4_RF1_PU INTEGER,                   -- Pop-ups en RF1
  HM4_RF1_GBNT INTEGER,                 -- Ground bunts en RF1
  HM4_RF1_PUB INTEGER,                  -- Popup bunts en RF1
  HM4_RF1_LDB INTEGER,                  -- Line drive bunts en RF1
  HM4_RF2_FB INTEGER,                   -- Fly balls en RF2
  HM4_RF2_GB INTEGER,                   -- Ground balls en RF2
  HM4_RF2_LD INTEGER,                   -- Line drives en RF2
  HM4_RF2_PU INTEGER,                   -- Pop-ups en RF2
  HM4_RF2_GBNT INTEGER,                 -- Ground bunts en RF2
  HM4_RF2_PUB INTEGER,                  -- Popup bunts en RF2
  HM4_RF2_LDB INTEGER,                  -- Line drive bunts en RF2
  HM4_LF1_FB INTEGER,                   -- Fly balls en LF1
  HM4_LF1_GB INTEGER,                   -- Ground balls en LF1
  HM4_LF1_LD INTEGER,                   -- Line drives en LF1
  HM4_LF1_PU INTEGER,                   -- Pop-ups en LF1
  HM4_LF1_GBNT INTEGER,                 -- Ground bunts en LF1
  HM4_LF1_PUB INTEGER,                  -- Popup bunts en LF1
  HM4_LF1_LDB INTEGER,                  -- Line drive bunts en LF1
  HM4_LF2_FB INTEGER,                   -- Fly balls en LF2
  HM4_LF2_GB INTEGER,                   -- Ground balls en LF2
  HM4_LF2_LD INTEGER,                   -- Line drives en LF2
  HM4_LF2_PU INTEGER,                   -- Pop-ups en LF2
  HM4_LF2_GBNT INTEGER,                 -- Ground bunts en LF2
  HM4_LF2_PUB INTEGER,                  -- Popup bunts en LF2
  HM4_LF2_LDB INTEGER,                  -- Line drive bunts en LF2
  -- HM8: Heat map en 8 octantes
  HM8_RF1 INTEGER,                      -- Pelotas en juego en octante RF1
  HM8_RF2 INTEGER,                      -- Pelotas en juego en octante RF2
  HM8_RF3 INTEGER,                      -- Pelotas en juego en octante RF3
  HM8_RF4 INTEGER,                      -- Pelotas en juego en octante RF4
  HM8_LF1 INTEGER,                      -- Pelotas en juego en octante LF1
  HM8_LF2 INTEGER,                      -- Pelotas en juego en octante LF2
  HM8_LF3 INTEGER,                      -- Pelotas en juego en octante LF3
  HM8_LF4 INTEGER,                      -- Pelotas en juego en octante LF4
  HM8_FHP INTEGER,                      -- Fouls cerca de home plate
  HM8_FLF INTEGER,                      -- Fouls hacia left field
  HM8_FRF INTEGER,                      -- Fouls hacia right field
  HM8_LF1_X1B INTEGER,                  -- Sencillos en LF1
  HM8_LF1_X2B INTEGER,                  -- Dobles en LF1
  HM8_LF1_X3B INTEGER,                  -- Triples en LF1
  HM8_LF1_HR INTEGER,                   -- Jonrones en LF1
  HM8_LF1_H INTEGER,                    -- Hits totales en LF1
  HM8_LF2_X1B INTEGER,                  -- Sencillos en LF2
  HM8_LF2_X2B INTEGER,                  -- Dobles en LF2
  HM8_LF2_X3B INTEGER,                  -- Triples en LF2
  HM8_LF2_HR INTEGER,                   -- Jonrones en LF2
  HM8_LF2_H INTEGER,                    -- Hits totales en LF2
  HM8_LF3_X1B INTEGER,                  -- Sencillos en LF3
  HM8_LF3_X2B INTEGER,                  -- Dobles en LF3
  HM8_LF3_X3B INTEGER,                  -- Triples en LF3
  HM8_LF3_HR INTEGER,                   -- Jonrones en LF3
  HM8_LF3_H INTEGER,                    -- Hits totales en LF3
  HM8_LF4_X1B INTEGER,                  -- Sencillos en LF4
  HM8_LF4_X2B INTEGER,                  -- Dobles en LF4
  HM8_LF4_X3B INTEGER,                  -- Triples en LF4
  HM8_LF4_HR INTEGER,                   -- Jonrones en LF4
  HM8_LF4_H INTEGER,                    -- Hits totales en LF4
  HM8_RF1_X1B INTEGER,                  -- Sencillos en RF1
  HM8_RF1_X2B INTEGER,                  -- Dobles en RF1
  HM8_RF1_X3B INTEGER,                  -- Triples en RF1
  HM8_RF1_HR INTEGER,                   -- Jonrones en RF1
  HM8_RF1_H INTEGER,                    -- Hits totales en RF1
  HM8_RF2_X1B INTEGER,                  -- Sencillos en RF2
  HM8_RF2_X2B INTEGER,                  -- Dobles en RF2
  HM8_RF2_X3B INTEGER,                  -- Triples en RF2
  HM8_RF2_HR INTEGER,                   -- Jonrones en RF2
  HM8_RF2_H INTEGER,                    -- Hits totales en RF2
  HM8_RF3_X1B INTEGER,                  -- Sencillos en RF3
  HM8_RF3_X2B INTEGER,                  -- Dobles en RF3
  HM8_RF3_X3B INTEGER,                  -- Triples en RF3
  HM8_RF3_HR INTEGER,                   -- Jonrones en RF3
  HM8_RF3_H INTEGER,                    -- Hits totales en RF3
  HM8_RF4_X1B INTEGER,                  -- Sencillos en RF4
  HM8_RF4_X2B INTEGER,                  -- Dobles en RF4
  HM8_RF4_X3B INTEGER,                  -- Triples en RF4
  HM8_RF4_HR INTEGER,                   -- Jonrones en RF4
  HM8_RF4_H INTEGER,                    -- Hits totales en RF4
  HM8_RF1_FB INTEGER,                   -- Fly balls en RF1
  HM8_RF1_GB INTEGER,                   -- Ground balls en RF1
  HM8_RF1_LD INTEGER,                   -- Line drives en RF1
  HM8_RF1_PU INTEGER,                   -- Pop-ups en RF1
  HM8_RF1_GBNT INTEGER,                 -- Ground bunts en RF1
  HM8_RF1_PUB INTEGER,                  -- Popup bunts en RF1
  HM8_RF1_LDB INTEGER,                  -- Line drive bunts en RF1
  HM8_RF2_FB INTEGER,                   -- Fly balls en RF2
  HM8_RF2_GB INTEGER,                   -- Ground balls en RF2
  HM8_RF2_LD INTEGER,                   -- Line drives en RF2
  HM8_RF2_PU INTEGER,                   -- Pop-ups en RF2
  HM8_RF2_GBNT INTEGER,                 -- Ground bunts en RF2
  HM8_RF2_PUB INTEGER,                  -- Popup bunts en RF2
  HM8_RF2_LDB INTEGER,                  -- Line drive bunts en RF2
  HM8_RF3_FB INTEGER,                   -- Fly balls en RF3
  HM8_RF3_GB INTEGER,                   -- Ground balls en RF3
  HM8_RF3_LD INTEGER,                   -- Line drives en RF3
  HM8_RF3_PU INTEGER,                   -- Pop-ups en RF3
  HM8_RF3_GBNT INTEGER,                 -- Ground bunts en RF3
  HM8_RF3_PUB INTEGER,                  -- Popup bunts en RF3
  HM8_RF3_LDB INTEGER,                  -- Line drive bunts en RF3
  HM8_RF4_FB INTEGER,                   -- Fly balls en RF4
  HM8_RF4_GB INTEGER,                   -- Ground balls en RF4
  HM8_RF4_LD INTEGER,                   -- Line drives en RF4
  HM8_RF4_PU INTEGER,                   -- Pop-ups en RF4
  HM8_RF4_GBNT INTEGER,                 -- Ground bunts en RF4
  HM8_RF4_PUB INTEGER,                  -- Popup bunts en RF4
  HM8_RF4_LDB INTEGER,                  -- Line drive bunts en RF4
  HM8_LF1_FB INTEGER,                   -- Fly balls en LF1
  HM8_LF1_GB INTEGER,                   -- Ground balls en LF1
  HM8_LF1_LD INTEGER,                   -- Line drives en LF1
  HM8_LF1_PU INTEGER,                   -- Pop-ups en LF1
  HM8_LF1_GBNT INTEGER,                 -- Ground bunts en LF1
  HM8_LF1_PUB INTEGER,                  -- Popup bunts en LF1
  HM8_LF1_LDB INTEGER,                  -- Line drive bunts en LF1
  HM8_LF2_FB INTEGER,                   -- Fly balls en LF2
  HM8_LF2_GB INTEGER,                   -- Ground balls en LF2
  HM8_LF2_LD INTEGER,                   -- Line drives en LF2
  HM8_LF2_PU INTEGER,                   -- Pop-ups en LF2
  HM8_LF2_GBNT INTEGER,                 -- Ground bunts en LF2
  HM8_LF2_PUB INTEGER,                  -- Popup bunts en LF2
  HM8_LF2_LDB INTEGER,                  -- Line drive bunts en LF2
  HM8_LF3_FB INTEGER,                   -- Fly balls en LF3
  HM8_LF3_GB INTEGER,                   -- Ground balls en LF3
  HM8_LF3_LD INTEGER,                   -- Line drives en LF3
  HM8_LF3_PU INTEGER,                   -- Pop-ups en LF3
  HM8_LF3_GBNT INTEGER,                 -- Ground bunts en LF3
  HM8_LF3_PUB INTEGER,                  -- Popup bunts en LF3
  HM8_LF3_LDB INTEGER,                  -- Line drive bunts en LF3
  HM8_LF4_FB INTEGER,                   -- Fly balls en LF4
  HM8_LF4_GB INTEGER,                   -- Ground balls en LF4
  HM8_LF4_LD INTEGER,                   -- Line drives en LF4
  HM8_LF4_PU INTEGER,                   -- Pop-ups en LF4
  HM8_LF4_GBNT INTEGER,                 -- Ground bunts en LF4
  HM8_LF4_PUB INTEGER,                  -- Popup bunts en LF4
  HM8_LF4_LDB INTEGER,                  -- Line drive bunts en LF4
  -- Atributos de nombres (poblados por update_table_attributes)
  majorLeague TEXT,                      -- Nombre de la liga
  playerName TEXT,                       -- Nombre del jugador
  teamName TEXT,                         -- Nombre del equipo
  venueName TEXT                         -- Nombre del estadio
);

CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_groupingId ON agg_batting_balls_in_play_heatmaps(groupingId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_groupingDescription ON agg_batting_balls_in_play_heatmaps(groupingDescription);
CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_majorLeagueId ON agg_batting_balls_in_play_heatmaps(majorLeagueId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_seasonId ON agg_batting_balls_in_play_heatmaps(seasonId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_venueId ON agg_batting_balls_in_play_heatmaps(venueId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_teamId ON agg_batting_balls_in_play_heatmaps(teamId);
CREATE INDEX IF NOT EXISTS idx_agg_batting_balls_in_play_heatmaps_playerId ON agg_batting_balls_in_play_heatmaps(playerId);
