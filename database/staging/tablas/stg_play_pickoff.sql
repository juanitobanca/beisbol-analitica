DROP TABLE IF EXISTS stg_play_pickoff;

-- Staging: Intentos de pickoff (fuente: MLB Stats API play-by-play)
CREATE TABLE IF NOT EXISTS stg_play_pickoff (
  description TEXT,        -- Descripción narrativa del intento de pickoff
  code TEXT,               -- Código del resultado
  hasReview INTEGER,       -- 1 si hubo revisión de video
  fromCatcher INTEGER,     -- 1 si el intento fue del catcher (vs del pitcher)
  balls TEXT,              -- Conteo de bolas al momento del pickoff
  strikes TEXT,            -- Conteo de strikes al momento del pickoff
  outs TEXT,               -- Conteo de outs al momento del pickoff
  atBatIndex INTEGER,      -- Índice del turno al bate
  gamePk INTEGER,          -- ID único del juego
  `index` INTEGER,         -- Índice secuencial dentro del turno
  playId TEXT,             -- ID único de la jugada
  isPitch INTEGER          -- 0 ya que no es un pitcheo
);
