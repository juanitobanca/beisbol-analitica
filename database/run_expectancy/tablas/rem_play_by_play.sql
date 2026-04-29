DROP TABLE IF EXISTS rem_play_by_play;

-- Run Expectancy: Jugada por jugada enriquecida con estado de corredores y carreras — base para calcular la matriz de expectativa de carreras
CREATE TABLE IF NOT EXISTS rem_play_by_play (
  majorLeagueId INTEGER,                 -- ID de la liga mayor
  seasonId REAL,                         -- Año de la temporada
  venueId INTEGER,                       -- ID del estadio
  gameType2 TEXT,                        -- Tipo de juego: "RS"=temporada regular, "PS"=postemporada
  gamePk INTEGER,                        -- ID único del juego
  inning INTEGER,                        -- Número de inning
  halfInning TEXT,                       -- Mitad del inning: "top" o "bottom"
  atBatIndex INTEGER,                    -- Índice del turno al bate
  playIndex INTEGER,                     -- Índice de la jugada dentro del turno
  strikesBeforePlay INTEGER,             -- Strikes antes de la jugada
  ballsBeforePlay INTEGER,              -- Bolas antes de la jugada
  event TEXT,                            -- Evento de la jugada (ej: "Single", "Strikeout")
  runnersBeforePlay TEXT,                -- Estado de bases antes de la jugada (ej: "1B_2B_", "_2B_3B")
  menOnBaseBeforePlay TEXT,              -- Situación simplificada de bases antes: "Empty", "Men_On", etc.
  runsScoredBeforePlay INTEGER,          -- Carreras anotadas en el inning antes de esta jugada
  outsBeforePlay INTEGER,                -- Outs antes de la jugada
  runsScoredInPlay INTEGER,              -- Carreras anotadas en esta jugada
  outsInPlay INTEGER,                    -- Outs registrados en esta jugada
  runsScoredAfterPlay INTEGER,           -- Carreras acumuladas después de la jugada
  outsAfterPlay INTEGER,                 -- Outs acumulados después de la jugada
  runnersAfterPlay TEXT,                 -- Estado de bases después de la jugada
  menOnBaseAfterPlay TEXT,               -- Situación simplificada de bases después
  runsScoredEndInning INTEGER,           -- Total de carreras al final del inning
  battingTeamId INTEGER,                 -- ID del equipo al bate
  pitchingTeamId INTEGER,                -- ID del equipo que pitchea
  batterId INTEGER,                      -- ID del bateador
  batSide TEXT,                          -- Lado de bateo: "L", "R" o "S"
  pitcherId INTEGER,                     -- ID del pitcher
  pitchHand TEXT,                        -- Mano del pitcher: "L" o "R"
  responsiblePitcherId INTEGER,          -- ID del pitcher responsable del corredor
  runnerId INTEGER,                      -- ID del corredor involucrado
  scheduledInnings INTEGER,              -- Innings programados (normalmente 9)
  battingTeamScore INTEGER,              -- Marcador del equipo al bate
  pitchingTeamScore INTEGER,             -- Marcador del equipo que pitchea
  battingTeamScoreEndGame INTEGER,       -- Marcador final del equipo al bate
  pitchingTeamScoreEndGame INTEGER,      -- Marcador final del equipo que pitchea
  isPlateAppearance BOOLEAN              -- TRUE si la jugada cuenta como aparición al plato
);

CREATE INDEX IF NOT EXISTS idx_rem_play_by_play_gamePk_atBatIndex_playIndex ON rem_play_by_play(gamePk, atBatIndex, playIndex);

-- For Win Probability Added
CREATE INDEX IF NOT EXISTS idx_rem_play_by_play_majorLeague_inning ON rem_play_by_play(majorLeagueId, inning);
