DROP TABLE IF EXISTS fielding_credits; 

CREATE TABLE fielding_credits (
gamePk INTEGER,
atBatIndex INTEGER,
playerId INTEGER,
positionAbbrev TEXT,
credit TEXT
);