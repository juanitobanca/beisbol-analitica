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

CREATE INDEX gamePk_substitutionAtBatIndex_substitutionPlayIndex_defensive_substitutions ON defensive_substitutions(gamePk,substitutionAtBatIndex,substitutionPlayIndex);
CREATE INDEX gamePk_atBatIndex_playIndex_defensive_substitutions ON defensive_substitutions(gamePk,atBatIndex,playIndex);