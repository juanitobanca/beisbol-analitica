DROP TABLE IF EXISTS atbats;

-- Base: Turnos al bate con resultado, conteo y contexto (limpiado de stg_play_atbat)
CREATE TABLE atbats (
  gamePk INTEGER,                -- ID único del juego
  inning INTEGER,                -- Número de inning
  halfInning TEXT,               -- Mitad del inning: "top" o "bottom"
  atBatIndex INTEGER,            -- Índice secuencial del turno al bate en el juego
  battingTeamId INTEGER,         -- ID del equipo al bate
  pitchingTeamId INTEGER,        -- ID del equipo que pitchea
  endOuts INTEGER,               -- Outs al final del turno
  endBalls INTEGER,              -- Bolas al final del turno
  endStrikes INTEGER,            -- Strikes al final del turno
  batterId INTEGER,              -- ID del bateador
  pitcherId INTEGER,             -- ID del pitcher
  hasOut INTEGER,                -- 1 si hubo al menos un out en la jugada
  hasReview INTEGER,             -- 1 si hubo revisión de video
  isScoringPlay INTEGER,         -- 1 si se anotó al menos una carrera
  rbi INTEGER,                   -- Carreras impulsadas en este turno
  awayScore INTEGER,             -- Marcador visitante después de la jugada
  homeScore INTEGER,             -- Marcador local después de la jugada
  event TEXT,                    -- Resultado del turno (ej: "Single", "Strikeout", "Home Run")
  eventType TEXT,                -- Código del evento (ej: "single", "strikeout", "home_run")
  batSide TEXT,                  -- Lado de bateo: "L", "R" o "S" (switch)
  pitchHand TEXT,                -- Mano del pitcher: "L" o "R"
  menOnBase TEXT,                -- Situación de bases: "Empty", "Men_On", "Loaded", "RISP"
  description TEXT,              -- Descripción narrativa de la jugada
  pitches INTEGER,               -- Número de pitcheos en el turno
  HM4 TEXT,                      -- Zona de heat map en 4 cuadrantes donde cayó la pelota
  HM8 TEXT,                      -- Zona de heat map en 8 octantes donde cayó la pelota
  PRIMARY KEY(gamePk, atBatIndex)
);

CREATE INDEX IF NOT EXISTS idx_atbats_gamePk ON atbats(gamePk);
CREATE INDEX IF NOT EXISTS idx_atbats_batterId ON atbats(batterId);
CREATE INDEX IF NOT EXISTS idx_atbats_pitcherId ON atbats(pitcherId);
