USE baseball;

DROP TABLE rem_play_by_play;

CREATE TABLE IF NOT EXISTS rem_play_by_play (
  majorLeagueId INTEGER,
  seasonId DOUBLE,
  venueId INTEGER,
  gameType2 VARCHAR(10),
  gamePk INTEGER,
  inning INTEGER,
  halfInning VARCHAR(15),
  atBatIndex INTEGER,
  playIndex INTEGER,
  strikesBeforePlay INTEGER,
  ballsBeforePlay INTEGER,
  event VARCHAR(100),
  runnersBeforePlay VARCHAR(3),
  menOnBaseBeforePlay VARCHAR(10),
  runsScoredBeforePlay INTEGER,
  outsBeforePlay INTEGER,
  runsScoredInPlay INTEGER,
  outsInPlay INTEGER,
  runsScoredAfterPlay INTEGER,
  outsAfterPlay INTEGER,
  runnersAfterPlay VARCHAR(3),
  menOnBaseAfterPlay VARCHAR(10),
  runsScoredEndInning INTEGER,
  battingTeamId INTEGER,
  pitchingTeamId INTEGER,
  batterId INTEGER,
  batSide VARCHAR(1),
  pitcherId INTEGER,
  pitchHand VARCHAR(1),
  responsiblePitcherId INTEGER,
  runnerId INTEGER,
  scheduledInnings INTEGER,
  battingTeamScore INTEGER,
  pitchingTeamScore INTEGER,
  battingTeamScoreEndGame INTEGER,
  pitchingTeamScoreEndGame INTEGER,
  isPlateAppearance BOOLEAN
);

ALTER TABLE rem_play_by_play ADD INDEX(gamePk, atBatIndex, playIndex);
