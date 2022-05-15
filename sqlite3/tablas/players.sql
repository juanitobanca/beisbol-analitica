DROP TABLE IF EXISTS players; 

CREATE TABLE players (
playerId INTEGER,
firstName TEXT,
lastName TEXT,
fullName TEXT,
birthDate TEXT,
birthCity TEXT,
birthStateProvince TEXT,
birthCountry TEXT,
strikeZoneTop REAL,
strikeZoneBottom REAL,
positionAbbrev TEXT,
batSide TEXT,
pitchHand TEXT
);