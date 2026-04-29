DROP TABLE IF EXISTS defensive_substitutions;

-- Base: Sustituciones defensivas — rastrea qué jugador reemplazó a quién y en qué posición
CREATE TABLE defensive_substitutions (
  gamePk INTEGER,                        -- ID único del juego
  inning INTEGER,                        -- Inning donde ocurrió la sustitución
  halfInning TEXT,                       -- Mitad del inning: "top" o "bottom"
  atBatIndex INTEGER,                    -- Índice del turno al bate cuando ocurrió
  playIndex INTEGER,                     -- Índice de la jugada cuando ocurrió
  substitutionAtBatIndex INTEGER,        -- Índice del turno al bate de la sustitución efectiva
  substitutionPlayIndex INTEGER,         -- Índice de la jugada de la sustitución efectiva
  battingTeamId INTEGER,                 -- ID del equipo al bate
  pitchingTeamId INTEGER,                -- ID del equipo que pitchea
  outs INTEGER,                          -- Outs al momento de la sustitución
  playerId INTEGER,                      -- ID del jugador que fue sustituido
  positionAbbrev TEXT,                   -- Posición del jugador sustituido (ej: "LF", "2B")
  substitutingPlayerId INTEGER,          -- ID del jugador que entró como sustituto
  substitutingInning INTEGER,            -- Inning de la sustitución efectiva
  substitutingOuts INTEGER,              -- Outs de la sustitución efectiva
  PRIMARY KEY(gamePk, atBatIndex, playIndex)
);

CREATE INDEX IF NOT EXISTS idx_defensive_substitutions_gamePk_substitutionAtBatIndex_substitutionPlayIndex ON defensive_substitutions(gamePk, substitutionAtBatIndex, substitutionPlayIndex);
