DROP TABLE IF EXISTS transactions; 

CREATE TABLE transactions (
transactionId INTEGER,
personId INTEGER,
toTeamId INTEGER,
teamId INTEGER,
transactionDate TEXT,
effectiveDate TEXT,
resolutionDate TEXT,
typeCode TEXT,
typeDesc TEXT,
description TEXT
);

