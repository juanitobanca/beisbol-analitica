USE baseball;

DROP TABLE transactions;

CREATE TABLE transactions (
  transactionId INTEGER,
  personId INTEGER,
  toTeamId INTEGER,
  teamId INTEGER,
  transactionDate VARCHAR(100),
  effectiveDate  VARCHAR(100),
  resolutionDate  VARCHAR(100),
  typeCode  VARCHAR(100),
  typeDesc  VARCHAR(100),
  description  VARCHAR(1000)
)  ENGINE = INNODB;
