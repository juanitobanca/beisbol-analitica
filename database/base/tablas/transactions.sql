DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
  transactionId INTEGER,
  personId INTEGER,
  toTeamId INTEGER,
  teamId INTEGER,
  transactionDate TEXT,
  effectiveDate  TEXT,
  resolutionDate  TEXT,
  typeCode  TEXT,
  typeDesc  TEXT,
  description  TEXT
);

CREATE INDEX IF NOT EXISTS idx_transactions_transactionId ON transactions(transactionId);
CREATE INDEX IF NOT EXISTS idx_transactions_personId ON transactions(personId);
CREATE INDEX IF NOT EXISTS idx_transactions_toTeamId ON transactions(toTeamId);
CREATE INDEX IF NOT EXISTS idx_transactions_teamId ON transactions(teamId);
