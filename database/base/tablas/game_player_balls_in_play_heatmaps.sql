DROP TABLE IF EXISTS game_player_balls_in_play_heatmaps;

-- Base: Heat maps de pelotas en juego por turno al bate — distribución de batazos en 4 cuadrantes (HM4) y 8 octantes (HM8)
-- Cada zona tiene conteos por tipo de hit (X1B, X2B, X3B, HR, H) y trayectoria (FB, GB, LD, PU, GBNT, PUB, LDB)
-- Convenciones: RF=right field, LF=left field, FHP=foul home plate, FLF=foul left field, FRF=foul right field
CREATE TABLE game_player_balls_in_play_heatmaps (
  gamePk INTEGER,                -- ID único del juego
  atBatIndex INTEGER,            -- Índice del turno al bate
  battingTeamId INTEGER,         -- ID del equipo al bate
  batterId INTEGER,              -- ID del bateador
  batSide TEXT,                  -- Lado de bateo: "L", "R" o "S"
  pitchingTeamId INTEGER,        -- ID del equipo que pitchea
  pitcherId INTEGER,             -- ID del pitcher
  pitchHand TEXT,                -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  -- HM4: Heat map en 4 cuadrantes — conteos de pelotas en juego
  HM4_RF1 INTEGER,               -- Pelotas en juego en cuadrante RF1 (right field cercano)
  HM4_RF2 INTEGER,               -- Pelotas en juego en cuadrante RF2 (right field lejano)
  HM4_LF1 INTEGER,               -- Pelotas en juego en cuadrante LF1 (left field cercano)
  HM4_LF2 INTEGER,               -- Pelotas en juego en cuadrante LF2 (left field lejano)
  HM4_FHP INTEGER,               -- Fouls cerca de home plate
  HM4_FLF INTEGER,               -- Fouls hacia left field
  HM4_FRF INTEGER,               -- Fouls hacia right field
  HM4_LF1_X1B INTEGER,           -- Sencillos en LF1
  HM4_LF1_X2B INTEGER,           -- Dobles en LF1
  HM4_LF1_X3B INTEGER,           -- Triples en LF1
  HM4_LF1_HR INTEGER,            -- Jonrones en LF1
  HM4_LF1_H INTEGER,             -- Hits totales en LF1
  HM4_LF2_X1B INTEGER,           -- Sencillos en LF2
  HM4_LF2_X2B INTEGER,           -- Dobles en LF2
  HM4_LF2_X3B INTEGER,           -- Triples en LF2
  HM4_LF2_HR INTEGER,            -- Jonrones en LF2
  HM4_LF2_H INTEGER,             -- Hits totales en LF2
  HM4_RF1_X1B INTEGER,           -- Sencillos en RF1
  HM4_RF1_X2B INTEGER,           -- Dobles en RF1
  HM4_RF1_X3B INTEGER,           -- Triples en RF1
  HM4_RF1_HR INTEGER,            -- Jonrones en RF1
  HM4_RF1_H INTEGER,             -- Hits totales en RF1
  HM4_RF2_X1B INTEGER,           -- Sencillos en RF2
  HM4_RF2_X2B INTEGER,           -- Dobles en RF2
  HM4_RF2_X3B INTEGER,           -- Triples en RF2
  HM4_RF2_HR INTEGER,            -- Jonrones en RF2
  HM4_RF2_H INTEGER,             -- Hits totales en RF2
  HM4_RF1_FB INTEGER,            -- Fly balls en RF1
  HM4_RF1_GB INTEGER,            -- Ground balls en RF1
  HM4_RF1_LD INTEGER,            -- Line drives en RF1
  HM4_RF1_PU INTEGER,            -- Pop-ups en RF1
  HM4_RF1_GBNT INTEGER,          -- Ground bunts en RF1
  HM4_RF1_PUB INTEGER,           -- Popup bunts en RF1
  HM4_RF1_LDB INTEGER,           -- Line drive bunts en RF1
  HM4_RF2_FB INTEGER,            -- Fly balls en RF2
  HM4_RF2_GB INTEGER,            -- Ground balls en RF2
  HM4_RF2_LD INTEGER,            -- Line drives en RF2
  HM4_RF2_PU INTEGER,            -- Pop-ups en RF2
  HM4_RF2_GBNT INTEGER,          -- Ground bunts en RF2
  HM4_RF2_PUB INTEGER,           -- Popup bunts en RF2
  HM4_RF2_LDB INTEGER,           -- Line drive bunts en RF2
  HM4_LF1_FB INTEGER,            -- Fly balls en LF1
  HM4_LF1_GB INTEGER,            -- Ground balls en LF1
  HM4_LF1_LD INTEGER,            -- Line drives en LF1
  HM4_LF1_PU INTEGER,            -- Pop-ups en LF1
  HM4_LF1_GBNT INTEGER,          -- Ground bunts en LF1
  HM4_LF1_PUB INTEGER,           -- Popup bunts en LF1
  HM4_LF1_LDB INTEGER,           -- Line drive bunts en LF1
  HM4_LF2_FB INTEGER,            -- Fly balls en LF2
  HM4_LF2_GB INTEGER,            -- Ground balls en LF2
  HM4_LF2_LD INTEGER,            -- Line drives en LF2
  HM4_LF2_PU INTEGER,            -- Pop-ups en LF2
  HM4_LF2_GBNT INTEGER,          -- Ground bunts en LF2
  HM4_LF2_PUB INTEGER,           -- Popup bunts en LF2
  HM4_LF2_LDB INTEGER,           -- Line drive bunts en LF2
  -- HM8: Heat map en 8 octantes — conteos de pelotas en juego
  HM8_RF1 INTEGER,               -- Pelotas en juego en octante RF1
  HM8_RF2 INTEGER,               -- Pelotas en juego en octante RF2
  HM8_RF3 INTEGER,               -- Pelotas en juego en octante RF3
  HM8_RF4 INTEGER,               -- Pelotas en juego en octante RF4
  HM8_LF1 INTEGER,               -- Pelotas en juego en octante LF1
  HM8_LF2 INTEGER,               -- Pelotas en juego en octante LF2
  HM8_LF3 INTEGER,               -- Pelotas en juego en octante LF3
  HM8_LF4 INTEGER,               -- Pelotas en juego en octante LF4
  HM8_FHP INTEGER,               -- Fouls cerca de home plate
  HM8_FLF INTEGER,               -- Fouls hacia left field
  HM8_FRF INTEGER,               -- Fouls hacia right field
  HM8_LF1_X1B INTEGER,           -- Sencillos en LF1
  HM8_LF1_X2B INTEGER,           -- Dobles en LF1
  HM8_LF1_X3B INTEGER,           -- Triples en LF1
  HM8_LF1_HR INTEGER,            -- Jonrones en LF1
  HM8_LF1_H INTEGER,             -- Hits totales en LF1
  HM8_LF2_X1B INTEGER,           -- Sencillos en LF2
  HM8_LF2_X2B INTEGER,           -- Dobles en LF2
  HM8_LF2_X3B INTEGER,           -- Triples en LF2
  HM8_LF2_HR INTEGER,            -- Jonrones en LF2
  HM8_LF2_H INTEGER,             -- Hits totales en LF2
  HM8_LF3_X1B INTEGER,           -- Sencillos en LF3
  HM8_LF3_X2B INTEGER,           -- Dobles en LF3
  HM8_LF3_X3B INTEGER,           -- Triples en LF3
  HM8_LF3_HR INTEGER,            -- Jonrones en LF3
  HM8_LF3_H INTEGER,             -- Hits totales en LF3
  HM8_LF4_X1B INTEGER,           -- Sencillos en LF4
  HM8_LF4_X2B INTEGER,           -- Dobles en LF4
  HM8_LF4_X3B INTEGER,           -- Triples en LF4
  HM8_LF4_HR INTEGER,            -- Jonrones en LF4
  HM8_LF4_H INTEGER,             -- Hits totales en LF4
  HM8_RF1_X1B INTEGER,           -- Sencillos en RF1
  HM8_RF1_X2B INTEGER,           -- Dobles en RF1
  HM8_RF1_X3B INTEGER,           -- Triples en RF1
  HM8_RF1_HR INTEGER,            -- Jonrones en RF1
  HM8_RF1_H INTEGER,             -- Hits totales en RF1
  HM8_RF2_X1B INTEGER,           -- Sencillos en RF2
  HM8_RF2_X2B INTEGER,           -- Dobles en RF2
  HM8_RF2_X3B INTEGER,           -- Triples en RF2
  HM8_RF2_HR INTEGER,            -- Jonrones en RF2
  HM8_RF2_H INTEGER,             -- Hits totales en RF2
  HM8_RF3_X1B INTEGER,           -- Sencillos en RF3
  HM8_RF3_X2B INTEGER,           -- Dobles en RF3
  HM8_RF3_X3B INTEGER,           -- Triples en RF3
  HM8_RF3_HR INTEGER,            -- Jonrones en RF3
  HM8_RF3_H INTEGER,             -- Hits totales en RF3
  HM8_RF4_X1B INTEGER,           -- Sencillos en RF4
  HM8_RF4_X2B INTEGER,           -- Dobles en RF4
  HM8_RF4_X3B INTEGER,           -- Triples en RF4
  HM8_RF4_HR INTEGER,            -- Jonrones en RF4
  HM8_RF4_H INTEGER,             -- Hits totales en RF4
  HM8_RF1_FB INTEGER,            -- Fly balls en RF1
  HM8_RF1_GB INTEGER,            -- Ground balls en RF1
  HM8_RF1_LD INTEGER,            -- Line drives en RF1
  HM8_RF1_PU INTEGER,            -- Pop-ups en RF1
  HM8_RF1_GBNT INTEGER,          -- Ground bunts en RF1
  HM8_RF1_PUB INTEGER,           -- Popup bunts en RF1
  HM8_RF1_LDB INTEGER,           -- Line drive bunts en RF1
  HM8_RF2_FB INTEGER,            -- Fly balls en RF2
  HM8_RF2_GB INTEGER,            -- Ground balls en RF2
  HM8_RF2_LD INTEGER,            -- Line drives en RF2
  HM8_RF2_PU INTEGER,            -- Pop-ups en RF2
  HM8_RF2_GBNT INTEGER,          -- Ground bunts en RF2
  HM8_RF2_PUB INTEGER,           -- Popup bunts en RF2
  HM8_RF2_LDB INTEGER,           -- Line drive bunts en RF2
  HM8_RF3_FB INTEGER,            -- Fly balls en RF3
  HM8_RF3_GB INTEGER,            -- Ground balls en RF3
  HM8_RF3_LD INTEGER,            -- Line drives en RF3
  HM8_RF3_PU INTEGER,            -- Pop-ups en RF3
  HM8_RF3_GBNT INTEGER,          -- Ground bunts en RF3
  HM8_RF3_PUB INTEGER,           -- Popup bunts en RF3
  HM8_RF3_LDB INTEGER,           -- Line drive bunts en RF3
  HM8_RF4_FB INTEGER,            -- Fly balls en RF4
  HM8_RF4_GB INTEGER,            -- Ground balls en RF4
  HM8_RF4_LD INTEGER,            -- Line drives en RF4
  HM8_RF4_PU INTEGER,            -- Pop-ups en RF4
  HM8_RF4_GBNT INTEGER,          -- Ground bunts en RF4
  HM8_RF4_PUB INTEGER,           -- Popup bunts en RF4
  HM8_RF4_LDB INTEGER,           -- Line drive bunts en RF4
  HM8_LF1_FB INTEGER,            -- Fly balls en LF1
  HM8_LF1_GB INTEGER,            -- Ground balls en LF1
  HM8_LF1_LD INTEGER,            -- Line drives en LF1
  HM8_LF1_PU INTEGER,            -- Pop-ups en LF1
  HM8_LF1_GBNT INTEGER,          -- Ground bunts en LF1
  HM8_LF1_PUB INTEGER,           -- Popup bunts en LF1
  HM8_LF1_LDB INTEGER,           -- Line drive bunts en LF1
  HM8_LF2_FB INTEGER,            -- Fly balls en LF2
  HM8_LF2_GB INTEGER,            -- Ground balls en LF2
  HM8_LF2_LD INTEGER,            -- Line drives en LF2
  HM8_LF2_PU INTEGER,            -- Pop-ups en LF2
  HM8_LF2_GBNT INTEGER,          -- Ground bunts en LF2
  HM8_LF2_PUB INTEGER,           -- Popup bunts en LF2
  HM8_LF2_LDB INTEGER,           -- Line drive bunts en LF2
  HM8_LF3_FB INTEGER,            -- Fly balls en LF3
  HM8_LF3_GB INTEGER,            -- Ground balls en LF3
  HM8_LF3_LD INTEGER,            -- Line drives en LF3
  HM8_LF3_PU INTEGER,            -- Pop-ups en LF3
  HM8_LF3_GBNT INTEGER,          -- Ground bunts en LF3
  HM8_LF3_PUB INTEGER,           -- Popup bunts en LF3
  HM8_LF3_LDB INTEGER,           -- Line drive bunts en LF3
  HM8_LF4_FB INTEGER,            -- Fly balls en LF4
  HM8_LF4_GB INTEGER,            -- Ground balls en LF4
  HM8_LF4_LD INTEGER,            -- Line drives en LF4
  HM8_LF4_PU INTEGER,            -- Pop-ups en LF4
  HM8_LF4_GBNT INTEGER,          -- Ground bunts en LF4
  HM8_LF4_PUB INTEGER,           -- Popup bunts en LF4
  HM8_LF4_LDB INTEGER            -- Line drive bunts en LF4
);

CREATE INDEX IF NOT EXISTS idx_game_player_balls_in_play_heatmaps_gamePk_atBatIndex ON game_player_balls_in_play_heatmaps(gamePk, atBatIndex);
