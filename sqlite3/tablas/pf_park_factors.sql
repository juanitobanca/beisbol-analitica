DROP TABLE IF EXISTS pf_park_factors; 

CREATE TABLE pf_park_factors (
groupingId INTEGER,
groupingDescription TEXT,
majorLeagueId INTEGER,
seasonId REAL,
venueId INTEGER,
teamId INTEGER,
homeGames INTEGER,
awayGames INTEGER,
runsScoredHome INTEGER,
runsAllowedHome INTEGER,
runsScoredAway INTEGER,
runsAllowedAway INTEGER,
singlesScoredHome INTEGER,
singlesAllowedHome INTEGER,
singlesScoredAway INTEGER,
singlesAllowedAway INTEGER,
doublesScoredHome INTEGER,
doublesAllowedHome INTEGER,
doublesScoredAway INTEGER,
doublesAllowedAway INTEGER,
triplesScoredHome INTEGER,
triplesAllowedHome INTEGER,
triplesScoredAway INTEGER,
triplesAllowedAway INTEGER,
homeRunsScoredHome INTEGER,
homeRunsAllowedHome INTEGER,
homeRunsScoredAway INTEGER,
homeRunsAllowedAway INTEGER,
strikeOutsScoredHome INTEGER,
strikeOutsAllowedHome INTEGER,
strikeOutsScoredAway INTEGER,
strikeOutsAllowedAway INTEGER,
unintentionalWalksScoredHome INTEGER,
unintentionalWalksAllowedHome INTEGER,
unintentionalWalksScoredAway INTEGER,
unintentionalWalksAllowedAway INTEGER,
flyBallsScoredHome INTEGER,
flyBallsAllowedHome INT
);

CREATE INDEX groupingDescription_pf_park_factors ON pf_park_factors(groupingDescription);
CREATE INDEX groupingId_pf_park_factors ON pf_park_factors(groupingId);
CREATE INDEX majorLeagueId_pf_park_factors ON pf_park_factors(majorLeagueId);
CREATE INDEX seasonId_pf_park_factors ON pf_park_factors(seasonId);
CREATE INDEX venueId_pf_park_factors ON pf_park_factors(venueId);