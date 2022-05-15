USE baseball;

DROP TABLE stg_box_team;

CREATE TABLE IF NOT EXISTS stg_box_team (
  abbreviation VARCHAR(100),
  active TINYINT,
  allStarStatus VARCHAR(100),
  fileCode VARCHAR(100),
  firstYearOfPlay VARCHAR(100),
  locationName VARCHAR(100),
  parentOrgId INTEGER,
  parentOrgName VARCHAR(100),
  season INTEGER,
  shortName VARCHAR(100),
  teamCode VARCHAR(100),
  teamName VARCHAR(100),
  id INTEGER,
  name VARCHAR(100),
  link VARCHAR(100),
  leagueId INTEGER,
  leagueName VARCHAR(100),
  leagueLink VARCHAR(100),
  venueId INTEGER,
  venueName VARCHAR(100),
  venueLink VARCHAR(100),
  divisionId INTEGER,
  divisionName VARCHAR(100),
  divisionLink VARCHAR(100),
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(20)
) ENGINE = INNODB;
