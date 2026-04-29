DROP TABLE IF EXISTS stg_box_team_fielding;

-- Staging: Totales de fildeo a nivel de equipo por juego (fuente: MLB Stats API boxscore)
 CREATE TABLE IF NOT EXISTS stg_box_team_fielding (
  assists INTEGER,           -- Asistencias del equipo (A)
  caughtStealing INTEGER,    -- Atrapados robando (CS)
  chances INTEGER,           -- Oportunidades de fildeo (TC)
  errors INTEGER,            -- Errores (E)
  passedBall INTEGER,        -- Bolas pasadas (PB)
  pickoffs INTEGER,          -- Pickoffs realizados
  putOuts INTEGER,           -- Outs directos (PO)
  stolenBases INTEGER,       -- Bases robadas permitidas (SB)
  gamePk INTEGER,            -- ID único del juego
  teamId INTEGER,            -- ID del equipo
  teamType TEXT              -- Tipo de equipo: "home" o "away"
);
