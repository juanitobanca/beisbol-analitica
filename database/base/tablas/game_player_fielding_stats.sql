DROP TABLE IF EXISTS game_player_fielding_stats;

-- Base: Estadísticas de fildeo por jugador por juego (limpiado de stg_box_player_fielding)
CREATE TABLE game_player_fielding_stats (
  gamePk INTEGER,                -- ID único del juego
  teamId INTEGER,                -- ID del equipo
  teamType TEXT,                 -- Tipo de equipo: "home" o "away"
  playerId INTEGER,              -- ID del jugador
  assists INTEGER,               -- Asistencias (A)
  caughtStealing INTEGER,        -- Atrapados robando (CS) - como receptor
  chances INTEGER,               -- Oportunidades de fildeo (TC)
  errors INTEGER,                -- Errores (E)
  passedBall INTEGER,            -- Bolas pasadas (PB) - como receptor
  pickoffs INTEGER,              -- Pickoffs realizados
  putOuts INTEGER,               -- Outs directos (PO)
  stolenBases INTEGER,           -- Bases robadas permitidas (SB) - como receptor
  PRIMARY KEY(gamePk, teamId, playerId)
);
