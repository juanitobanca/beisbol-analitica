DROP TABLE IF EXISTS major_leagues; 

CREATE TABLE major_leagues (
majorLeagueId INTEGER,
majorLeague TEXT
);

CREATE INDEX majorLeagueId_major_leagues ON major_leagues(majorLeagueId);