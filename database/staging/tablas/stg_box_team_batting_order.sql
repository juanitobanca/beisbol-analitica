DROP TABLE IF EXISTS stg_box_team_batting_order;

-- Staging: Orden de bateo por equipo por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_team_batting_order (
  gamePk INTEGER,          -- ID único del juego
  teamId INTEGER,          -- ID del equipo
  playerId INTEGER,        -- ID del jugador
  teamType TEXT,           -- Tipo de equipo: "home" o "away"
  battingOrder INTEGER     -- Posición en el orden de bateo (100=1ro, 200=2do, etc.)
);
