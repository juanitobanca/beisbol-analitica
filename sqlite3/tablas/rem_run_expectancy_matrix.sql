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