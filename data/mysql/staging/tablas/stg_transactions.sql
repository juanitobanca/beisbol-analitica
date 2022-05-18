USE baseball;

DROP TABLE stg_transactions;

CREATE TABLE stg_transactions (
  personId INTEGER,
  toTeamId INTEGER,
  teamId INTEGER,
  id INTEGER,
  transactionDate  VARCHAR(100),
  effectiveDate  VARCHAR(100),
  resolutionDate  VARCHAR(100),
  typeCode  VARCHAR(100),
  typeDesc  VARCHAR(100),
  description  VARCHAR(1000)
)  ENGINE = INNODB;
