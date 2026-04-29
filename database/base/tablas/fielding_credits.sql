DROP TABLE IF EXISTS fielding_credits;

-- Base: Créditos de fildeo por jugada — quién participó en cada out (limpiado de stg_play_credit)
CREATE TABLE fielding_credits (
  gamePk INTEGER,                -- ID único del juego
  atBatIndex INTEGER,            -- Índice del turno al bate
  playerId INTEGER,              -- ID del fildeador
  positionAbbrev TEXT,           -- Abreviatura de la posición (ej: "SS", "1B", "CF")
  credit TEXT                    -- Tipo de crédito: "f_assist", "f_putout", "f_fielded_ball"
);

CREATE INDEX IF NOT EXISTS idx_fielding_credits_gamePk_atBatIndex ON fielding_credits(gamePk, atBatIndex);
