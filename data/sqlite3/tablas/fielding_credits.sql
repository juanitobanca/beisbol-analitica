DROP TABLE IF EXISTS fielding_credits; 

CREATE TABLE fielding_credits (
gamePk INTEGER,
atBatIndex INTEGER,
playerId INTEGER,
positionAbbrev TEXT,
credit TEXT
);

CREATE INDEX gamePk_atBatIndex_fielding_credits ON fielding_credits(gamePk,atBatIndex);