USE baseball;

DROP TABLE agg_team_performance_stats;

CREATE TABLE agg_team_performance_stats (
  groupingId INTEGER UNSIGNED,
  groupingDescription VARCHAR(255),
  aggregationType VARCHAR(20),
  majorLeagueId INTEGER,
  seasonId DOUBLE,
  gameDate DATE,
  gameType2 VARCHAR(10),
  teamType VARCHAR(10),
  venueId INTEGER,
  teamId INTEGER,
  runs INTEGER,
  runsAllowed INTEGER,
  runDifferential INTEGER,
  wins INTEGER,
  losses INTEGER,
  winPercentage DOUBLE,
  pythagoreanExpectation DOUBLE,
  attendance INTEGER,
  -- Atributos
  majorLeague VARCHAR(10),
  teamName VARCHAR(100),
  venueName VARCHAR(100)
) ENGINE = INNODB;

ALTER TABLE agg_team_performance_stats ADD INDEX(groupingId);
ALTER TABLE agg_team_performance_stats ADD INDEX(groupingDescription(255));
ALTER TABLE agg_team_performance_stats ADD INDEX(majorLeagueId);
ALTER TABLE agg_team_performance_stats ADD INDEX(seasonId);
ALTER TABLE agg_team_performance_stats ADD INDEX(venueId);
ALTER TABLE agg_team_performance_stats ADD INDEX(teamId);
