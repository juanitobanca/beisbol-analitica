USE baseball;

DROP TABLE major_leagues;

CREATE TABLE major_leagues (
  majorLeagueId INTEGER,
  majorLeague VARCHAR(20)
) ENGINE = INNODB;

ALTER TABLE major_leagues ADD PRIMARY KEY(majorLeagueId);
