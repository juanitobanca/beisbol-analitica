DROP TABLE IF EXISTS actions; 

CREATE TABLE actions (
gamePk INTEGER,
inning INTEGER,
halfInning TEXT,
pitchingTeamId INTEGER,
battingTeamId INTEGER,
atBatIndex INTEGER,
playIndex INTEGER,
playerId REAL,
endOuts INTEGER,
endBalls INTEGER,
endStrikes INTEGER,
hasReview INTEGER,
isScoringPlay INTEGER,
awayScore INTEGER,
homeScore INTEGER,
event TEXT,
eventType TEXT,
battingOrder REAL,
positionAbbrev TEXT,
injuryType TEXT,
description TEXT
);

