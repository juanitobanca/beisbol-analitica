DROP TABLE IF EXISTS rem_run_expectancy_matrix; 

CREATE TABLE rem_run_expectancy_matrix (
groupingId INTEGER,
groupingDescription TEXT,
majorLeagueId INTEGER,
seasonId REAL,
venueId INTEGER,
runnersBeforePlay TEXT,
zeroOutsRunsScoredEndInning INTEGER,
zeroOutsRunsScoredBeforePlay INTEGER,
zeroOutsEvents INTEGER,
zeroOutsRunExpectancy REAL,
oneOutsRunsScoredEndInning INTEGER,
oneOutsRunsScoredBeforePlay INTEGER,
oneOutsEvents INTEGER,
oneOutsRunExpectancy REAL,
twoOutsRunsScoredEndInning INTEGER,
twoOutsRunsScoredBeforePlay INTEGER,
twoOutsEvents INTEGER,
twoOutsRunExpectancy REAL,
sortingOrder INTEGER,
majorLeague TEXT,
venueName TEXT
);

CREATE INDEX groupingId_rem_run_expectancy_matrix ON rem_run_expectancy_matrix(groupingId);
CREATE INDEX majorLeagueId_rem_run_expectancy_matrix ON rem_run_expectancy_matrix(majorLeagueId);
CREATE INDEX seasonId_rem_run_expectancy_matrix ON rem_run_expectancy_matrix(seasonId);
CREATE INDEX venueId_rem_run_expectancy_matrix ON rem_run_expectancy_matrix(venueId);