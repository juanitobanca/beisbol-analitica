DROP TABLE IF EXISTS defensive_substitutions; 

CREATE TABLE defensive_substitutions (
gamePk INTEGER,
inning INTEGER,
halfInning TEXT,
atBatIndex INTEGER,
playIndex INTEGER,
substitutionAtBatIndex INTEGER,
substitutionPlayIndex INTEGER,
battingTeamId INTEGER,
pitchingTeamId INTEGER,
outs INTEGER,
playerId INTEGER,
positionAbbrev TEXT,
substitutingPlayerId INTEGER,
substitutingInning INTEGER,
substitutingOuts INTEGER
);