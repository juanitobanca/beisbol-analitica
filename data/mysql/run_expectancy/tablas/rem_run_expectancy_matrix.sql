USE baseball;

DROP TABLE rem_run_expectancy_matrix;

CREATE TABLE IF NOT EXISTS rem_run_expectancy_matrix (
  groupingId INTEGER UNSIGNED,
  groupingDescription VARCHAR(255),
  majorLeagueId INTEGER,
  seasonId DOUBLE,
  venueId INTEGER,
  runnersBeforePlay VARCHAR(3),
  zeroOutsRunsScoredEndInning INTEGER,
  zeroOutsRunsScoredBeforePlay INTEGER,
  zeroOutsEvents INTEGER,
  zeroOutsRunExpectancy DOUBLE,
  oneOutsRunsScoredEndInning INTEGER,
  oneOutsRunsScoredBeforePlay INTEGER,
  oneOutsEvents INTEGER,
  oneOutsRunExpectancy DOUBLE,
  twoOutsRunsScoredEndInning INTEGER,
  twoOutsRunsScoredBeforePlay INTEGER,
  twoOutsEvents INTEGER,
  twoOutsRunExpectancy DOUBLE,
  sortingOrder INTEGER,
  majorLeague VARCHAR(10),
  venueName VARCHAR(100)
);

ALTER TABLE rem_run_expectancy_matrix ADD INDEX(groupingId);
ALTER TABLE rem_run_expectancy_matrix ADD INDEX(majorLeagueId);
ALTER TABLE rem_run_expectancy_matrix ADD INDEX(seasonId);
ALTER TABLE rem_run_expectancy_matrix ADD INDEX(venueId);
