USE baseball;

DROP TABLE defensive_substitutions;

CREATE TABLE defensive_substitutions (
  gamePk INTEGER,
  inning INTEGER,
  halfInning VARCHAR(15),
  atBatIndex INTEGER,
  playIndex INTEGER,
  substitutionAtBatIndex INTEGER,
  substitutionPlayIndex INTEGER,
  battingTeamId INTEGER,
  pitchingTeamId INTEGER,
  outs INTEGER,
  playerId INTEGER,
  positionAbbrev VARCHAR(10),
  substitutingPlayerId INTEGER,
  substitutingInning INTEGER,
  substitutingOuts INTEGER
) ENGINE = INNODB;

ALTER TABLE defensive_substitutions ADD PRIMARY KEY(gamePk, atBatIndex, playIndex);
ALTER TABLE defensive_substitutions ADD INDEX(gamePk, substitutionAtBatIndex, substitutionPlayIndex);
