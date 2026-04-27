DROP TABLE IF EXISTS stg_box_player_game_positions;

-- Staging: Posiciones jugadas por cada jugador en un juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_player_game_positions (
  code TEXT,         -- Código numérico de la posición (1=P, 2=C, 3=1B, etc.)
  name TEXT,         -- Nombre de la posición (ej: "Pitcher", "Shortstop")
  type TEXT,         -- Tipo de posición (ej: "Pitcher", "Infielder", "Outfielder")
  abbreviation TEXT,       -- Abreviatura (ej: "P", "C", "SS", "CF")
  gamePk INTEGER,    -- ID único del juego
  teamId INTEGER,    -- ID del equipo
  teamType TEXT,     -- Tipo de equipo: "home" o "away"
  playerId INTEGER   -- ID del jugador
);
