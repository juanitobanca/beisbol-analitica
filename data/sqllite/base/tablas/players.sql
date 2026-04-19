USE baseball;

DROP TABLE players;

CREATE TABLE players (
  playerId INTEGER,
  firstName VARCHAR(100),
  lastName VARCHAR(100),
  fullName VARCHAR(200),
  birthDate VARCHAR(100),
  birthCity VARCHAR(100),
  birthStateProvince VARCHAR(100),
  birthCountry VARCHAR(100),
  strikeZoneTop DOUBLE,
  strikeZoneBottom DOUBLE,
  positionAbbrev VARCHAR(10),
  batSide VARCHAR(10),
  pitchHand VARCHAR(10)
) ENGINE = INNODB;

ALTER TABLE players ADD PRIMARY KEY(playerId);
