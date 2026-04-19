USE baseball;

DROP TABLE stg_players;

CREATE TABLE IF NOT EXISTS stg_players (
  abbreviation VARCHAR(150),
  batSideCode VARCHAR(150),
  pitchHandCode VARCHAR(150),
  id INTEGER,
  fullName VARCHAR(150),
  link VARCHAR(150),
  firstName VARCHAR(150),
  lastName VARCHAR(150),
  birthDate VARCHAR(150),
  currentAge INTEGER,
  birthCity VARCHAR(150),
  birthStateProvince VARCHAR(150),
  birthCountry VARCHAR(150),
  height VARCHAR(150),
  weight INTEGER,
  active TINYINT,
  useName VARCHAR(150),
  middleName VARCHAR(150),
  boxscoreName VARCHAR(150),
  nameFirstLast VARCHAR(150),
  nameSlug VARCHAR(150),
  firstLastName VARCHAR(150),
  lastFirstName VARCHAR(150),
  lastInitName VARCHAR(150),
  initLastName VARCHAR(150),
  fullFMLName VARCHAR(150),
  fullLFMName VARCHAR(150),
  strikeZoneTop DOUBLE,
  strikeZoneBottom DOUBLE
) ENGINE = INNODB;
