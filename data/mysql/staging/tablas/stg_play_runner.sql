USE baseball;

DROP TABLE stg_play_runner;

CREATE TABLE IF NOT EXISTS stg_play_runner (
endBase VARCHAR(100),
isOut TINYINT,
outBase VARCHAR(100),
outNumber DOUBLE,
startBase VARCHAR(100),
earned TINYINT,
event VARCHAR(100),
eventType VARCHAR(100),
isScoringEvent TINYINT,
movementReason VARCHAR(100),
playIndex INTEGER,
rbi TINYINT,
responsiblePitcherId INTEGER,
teamUnearned TINYINT,
runnerId INTEGER,
gamePk INTEGER,
atBatIndex INTEGER
) ENGINE = INNODB;
