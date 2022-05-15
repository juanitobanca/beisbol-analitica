USE baseball;

DROP TABLE officials;

CREATE TABLE officials (
  officialId INTEGER,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  birthDate VARCHAR(100),
  birthCity VARCHAR(100),
  birthStateProvince VARCHAR(100),
  birthCountry VARCHAR(100)
) ENGINE = INNODB;

ALTER TABLE officials ADD PRIMARY KEY(officialId);
