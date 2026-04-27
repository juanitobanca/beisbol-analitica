DROP TABLE IF EXISTS stg_box_player_game_info;

-- Staging: Información del estado del jugador en el juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_player_game_info (
  isSubstitute INTEGER,      -- 1 si el jugador entró como sustituto
  isOnBench INTEGER,   -- 1 si el jugador está en la banca
  isCurrentPitcher INTEGER,  -- 1 si es el pitcher actual
  isCurrentBatter INTEGER,   -- 1 si es el bateador actual
  fullName TEXT,       -- Nombre completo del jugador
  link TEXT,     -- Enlace API del jugador
  abbreviation TEXT,   -- Abreviatura de la posición
  code TEXT,     -- Código numérico de la posición
  name TEXT,     -- Nombre de la posición
  type TEXT,     -- Tipo de posición (ej: "Pitcher", "Infielder")
  gamePk INTEGER,      -- ID único del juego
  teamId INTEGER,      -- ID del equipo
  teamType TEXT,       -- Tipo de equipo: "home" o "away"
  playerId INTEGER     -- ID del jugador
);
