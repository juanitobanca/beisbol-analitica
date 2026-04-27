DROP TABLE IF EXISTS stg_box_info;

-- Staging: Información del clima y asistencia por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_info(
  gamePk INTEGER,          -- ID único del juego en MLB Stats API
  weather TEXT,            -- Condiciones climáticas (ej: "72 degrees, Partly Cloudy")
  wind TEXT,               -- Condiciones de viento (ej: "8 mph, Out To CF")
  attendance TEXT          -- Asistencia del público al juego
);
