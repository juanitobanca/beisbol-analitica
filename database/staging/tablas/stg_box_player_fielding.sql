DROP TABLE IF EXISTS stg_box_player_fielding;

-- Staging: Estadísticas de fildeo por jugador por juego (fuente: MLB Stats API boxscore)
CREATE TABLE IF NOT EXISTS stg_box_player_fielding (
   assists REAL,      -- Asistencias (A)
   caughtStealing REAL,     -- Atrapados robando (CS) - como receptor
   chances REAL,      -- Oportunidades de fildeo (TC)
   errors REAL,       -- Errores (E)
   passedBall REAL,   -- Bolas pasadas (PB) - como receptor
   pickoffs REAL,     -- Pickoffs realizados
   putOuts REAL,      -- Outs directos (PO)
   stolenBases REAL,  -- Bases robadas permitidas (SB) - como receptor
   gamePk INTEGER,    -- ID único del juego
   teamId INTEGER,    -- ID del equipo
   teamType TEXT,     -- Tipo de equipo: "home" o "away"
   playerId INTEGER   -- ID del jugador
);
