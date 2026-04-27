DROP TABLE IF EXISTS rem_play_by_play;

CREATE TABLE IF NOT EXISTS rem_play_by_play (
  majorLeagueId INTEGER,
  seasonId REAL,
  venueId INTEGER,
  gameType2 TEXT,
  gamePk INTEGER,
  inning INTEGER,
  halfInning TEXT,
  atBatIndex INTEGER,
  playIndex INTEGER,
  strikesBeforePlay INTEGER,
  ballsBeforePlay INTEGER,
  event TEXT,
  runnersBeforePlay TEXT,
  menOnBaseBeforePlay TEXT,
  runsScoredBeforePlay INTEGER,
  outsBeforePlay INTEGER,
  runsScoredInPlay INTEGER,
  outsInPlay INTEGER,
  runsScoredAfterPlay INTEGER,
  outsAfterPlay INTEGER,
  runnersAfterPlay TEXT,
  menOnBaseAfterPlay TEXT,
  runsScoredEndInning INTEGER,
  battingTeamId INTEGER,
  pitchingTeamId INTEGER,
  batterId INTEGER,
  batSide TEXT,
  pitcherId INTEGER,
  pitchHand TEXT,
  responsiblePitcherId INTEGER,
  runnerId INTEGER,
  scheduledInnings INTEGER,
  battingTeamScore INTEGER,
  pitchingTeamScore INTEGER,
  battingTeamScoreEndGame INTEGER,
  pitchingTeamScoreEndGame INTEGER,
  isPlateAppearance BOOLEAN
);

CREATE INDEX IF NOT EXISTS idx_rem_play_by_play_gamePk_atBatIndex_playIndex ON rem_play_by_play(gamePk, atBatIndex, playIndex);

-- For Win Probability Added
CREATE INDEX IF NOT EXISTS idx_rem_play_by_play_majorLeague_inning ON rem_play_by_play(majorLeagueId, inning);
