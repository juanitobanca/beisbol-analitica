DROP TABLE IF EXISTS stg_transactions;

-- Staging: Transacciones de equipos (traspasos, liberaciones, asignaciones, etc.) (fuente: MLB Stats API transactions)
 CREATE TABLE stg_transactions (
  personId INTEGER,          -- ID del jugador involucrado
  toTeamId INTEGER,          -- ID del equipo destino
  teamId INTEGER,            -- ID del equipo origen
  id INTEGER,                -- ID único de la transacción
  transactionDate TEXT,      -- Fecha de la transacción (YYYY-MM-DD)
  effectiveDate TEXT,        -- Fecha efectiva de la transacción
  resolutionDate TEXT,       -- Fecha de resolución (para transacciones pendientes)
  typeCode TEXT,             -- Código del tipo de transacción (ej: "TR"=trade, "FA"=free agent)
  typeDesc TEXT,             -- Descripción del tipo de transacción
  description TEXT           -- Descripción completa de la transacción
);
