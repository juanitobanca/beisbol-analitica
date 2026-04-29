DROP TABLE IF EXISTS pickoffs;

-- Base: Intentos de pickoff por jugada (limpiado de stg_play_pickoff)
CREATE TABLE pickoffs (
  gamePk INTEGER,                -- ID único del juego
  atBatIndex INTEGER,            -- Índice del turno al bate
  playIndex INTEGER,             -- Índice secuencial dentro del turno
  outs INTEGER,                  -- Conteo de outs al momento del pickoff
  balls INTEGER,                 -- Conteo de bolas al momento del pickoff
  strikes INTEGER,               -- Conteo de strikes al momento del pickoff
  fromCatcher INTEGER,           -- 1 si el intento fue del catcher (vs del pitcher)
  hasReview INTEGER,             -- 1 si hubo revisión de video
  baseCode INTEGER               -- Código de la base (1=primera, 2=segunda, 3=tercera)
);

CREATE INDEX IF NOT EXISTS idx_pickoffs_gamePk_atBatIndex ON pickoffs(gamePk, atBatIndex);
