USE baseball;

DROP TABLE game_player_batting_stats;

CREATE TABLE game_player_batting_stats (
  gamePk INTEGER,
  teamId INTEGER,
  teamType VARCHAR(10),
  playerId INTEGER,
  atBats INTEGER,
  walks INTEGER,
  catchersInterference INTEGER,
  caughtStealing INTEGER,
  doubles INTEGER,
  flyOuts INTEGER,
  groundIntoDoublePlay INTEGER,
  groundIntoTriplePlay INTEGER,
  groundOuts INTEGER,
  hitByPitch INTEGER,
  hits INTEGER,
  homeRuns INTEGER,
  intentionalWalks INTEGER,
  leftOnBase INTEGER,
  pickoffs INTEGER,
  plateAppearances INTEGER,
  rbi INTEGER,
  runs INTEGER,
  sacBunts INTEGER,
  sacFlies INTEGER,
  singles INTEGER,
  stolenBases INTEGER,
  strikeOuts INTEGER,
  totalBases INTEGER,
  triples INTEGER,
  unintentionalWalks INTEGER
) ENGINE = INNODB;

ALTER TABLE game_player_batting_stats ADD PRIMARY KEY(gamePk, teamId, playerId);
