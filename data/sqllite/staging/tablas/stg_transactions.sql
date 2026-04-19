DROP TABLE IF EXISTS stg_transactions;

CREATE TABLE stg_transactions (
  personId INTEGER,
  toTeamId INTEGER,
  teamId INTEGER,
  id INTEGER,
  transactionDate TEXT,
  effectiveDate TEXT,
  resolutionDate TEXT,
  typeCode TEXT,
  typeDesc TEXT,
  description TEXT
);
