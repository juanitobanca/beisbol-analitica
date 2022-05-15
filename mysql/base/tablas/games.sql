USE baseball;

DROP TABLE games;

CREATE TABLE games (
  gamePk INTEGER,
  gameType VARCHAR(10),
  gameType2 VARCHAR(10),
  seasonId VARCHAR(20),
  gameDate DATE,
  isTie TINYINT,
  gameNumber INTEGER,
  majorLeague VARCHAR(20),
  majorLeagueId INTEGER,
  doubleHeader VARCHAR(10),
  dayNight VARCHAR(10),
  scheduledInnings INTEGER,
  gamesInSeries INTEGER,
  seriesDescription VARCHAR(30),
  ifNecessaryDescription VARCHAR(30),
  gameId VARCHAR(30),
  abstractGameState VARCHAR(30),
  codedGameState VARCHAR(30),
  detailedState VARCHAR(30),
  awayWins INTEGER,
  awayLosses INTEGER,
  awayPct DOUBLE,
  awayScore INTEGER,
  awayTeamId INTEGER,
  awayIsWinner TINYINT,
  homeWins INTEGER,
  homeLosses INTEGER,
  homePct DOUBLE,
  homeScore INTEGER,
  homeTeamId INTEGER,
  homeIsWinner TINYINT,
  venueId INTEGER,
  homeTeamName VARCHAR(100),
  awayTeamName VARCHAR(100),
  venueName VARCHAR(100),
  weather VARCHAR(100),
  wind VARCHAR(100),
  attendance INTEGER
) ENGINE = INNODB;

ALTER TABLE games ADD INDEX(gamePk);
-- ALTER TABLE games ADD PRIMARY KEY(gamePk); There's games that appear in more than one league. Hence, removing PK.
