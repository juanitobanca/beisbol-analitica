DROP TABLE IF EXISTS transactions;

-- Base: Transacciones de equipos — traspasos, liberaciones, asignaciones, etc. (limpiado de stg_transactions)
CREATE TABLE transactions (
  transactionId INTEGER,             -- ID único de la transacción
  personId INTEGER,                  -- ID del jugador involucrado
  toTeamId INTEGER,                  -- ID del equipo destino
  teamId INTEGER,                    -- ID del equipo origen
  transactionDate TEXT,              -- Fecha de la transacción (YYYY-MM-DD)
  effectiveDate  TEXT,               -- Fecha efectiva de la transacción
  resolutionDate  TEXT,              -- Fecha de resolución (para transacciones pendientes)
  typeCode  TEXT,                    -- Código del tipo (ej: "TR"=trade, "FA"=free agent, "ASG"=asignación)
  typeDesc  TEXT,                    -- Descripción del tipo de transacción
  description  TEXT                  -- Descripción completa de la transacción
);

CREATE INDEX IF NOT EXISTS idx_transactions_transactionId ON transactions(transactionId);
CREATE INDEX IF NOT EXISTS idx_transactions_personId ON transactions(personId);
CREATE INDEX IF NOT EXISTS idx_transactions_toTeamId ON transactions(toTeamId);
CREATE INDEX IF NOT EXISTS idx_transactions_teamId ON transactions(teamId);
