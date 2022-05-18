USE baseball;

DROP TABLE stg_box_team_pitching;

CREATE TABLE IF NOT EXISTS stg_box_team_pitching (
  airOuts INTEGER,
  atBats INTEGER,
  baseOnBalls INTEGER,
  battersFaced INTEGER,
  catchersInterference INTEGER,
  caughtStealing INTEGER,
  completeGames INTEGER,
  doubles INTEGER,
  earnedRuns INTEGER,
  groundOuts INTEGER,
  hitBatsmen INTEGER,
  hits INTEGER,
  homeRuns INTEGER,
  inheritedRunners INTEGER,
  inheritedRunnersScored INTEGER,
  intentionalWalks INTEGER,
  outs INTEGER,
  pickoffs INTEGER,
  rbi INTEGER,
  runs INTEGER,
  sacBunts INTEGER,
  sacFlies INTEGER,
  saveOpportunities INTEGER,
  shutouts INTEGER,
  stolenBases INTEGER,
  strikeOuts INTEGER,
  triples INTEGER,
  wildPitches INTEGER,
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(20)
) ENGINE = INNODB;
