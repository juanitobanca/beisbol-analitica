DROP TABLE IF EXISTS pickoffs; 

CREATE TABLE pickoffs (
gamePk INTEGER,
atBatIndex INTEGER,
playIndex INTEGER,
outs INTEGER,
balls INTEGER,
strikes INTEGER,
fromCatcher INTEGER,
hasReview INTEGER,
baseCode INTEGER
);