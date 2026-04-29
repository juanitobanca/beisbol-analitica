DROP TABLE IF EXISTS game_batting_orders;

-- Base: Orden de bateo por equipo por juego (limpiado de stg_box_team_batting_order)
CREATE TABLE game_batting_orders (
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  playerId INTEGER,              -- ID del jugador
  battingOrder INTEGER,          -- Posición en el orden de bateo (100=1ro, 200=2do, etc.)
  PRIMARY KEY(gamePk, teamId, playerId)
);
