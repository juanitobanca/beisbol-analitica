USE baseball;

DROP TABLE game_player_split_stats;

CREATE TABLE game_player_split_stats (
  gamePk INTEGER,
  atBatIndex INTEGER,
  battingTeamId INTEGER,
  batterId INTEGER,
  batSide VARCHAR(1),
  pitchingTeamId INTEGER,
  pitcherId INTEGER,
  pitchHand VARCHAR(1),
  menOnBase VARCHAR(10),
  -- These metrics come from atbats
  balks INTEGER,
  batterInterferences INTEGER,
  bunts INTEGER,
  catcherInterferences INTEGER,
  doubles INTEGER,
  fanInterferences INTEGER,
  fieldErrors INTEGER,
  fieldersChoice INTEGER,
  flyouts INTEGER,
  forceOuts INTEGER,
  groundedIntoDoublePlays INTEGER,
  groundOuts INTEGER,
  hitByPitch INTEGER,
  homeRuns INTEGER,
  intentionalWalks INTEGER,
  lineOuts INTEGER,
  passedBalls INTEGER,
  popOuts INTEGER,
  runsBattedIn INTEGER,
  sacBunts INTEGER,
  sacFlies INTEGER,
  singles INTEGER,
  strikeOuts INTEGER,
  triples INTEGER,
  triplePlays INTEGER,
  walks INTEGER,
  wildPitches INTEGER,
  -- These metrics come from pitches
  balls INTEGER,
  ballsPitchOut INTEGER,
  ballsInDirt INTEGER,
  intentBalls INTEGER,
  fouls INTEGER,
  foulBunts INTEGER,
  foulTips INTEGER,
  foulPitchOuts INTEGER,
  hitIntoPlay INTEGER,
  pitches INTEGER,
  pitchOuts INTEGER,
  strikes INTEGER,
  strikesCalled INTEGER,
  strikesPitchOuts INTEGER,
  missedBunts INTEGER,
  swingAndMissStrikes INTEGER,
  swingsPitchOuts INTEGER,
  swings INTEGER,
  -- Swings Per Ball and Strikes
  -- 0 Ball(s)
  swingsZeroAndZero INTEGER,
  swingsZeroAndOne INTEGER,
  swingsZeroAndTwo INTEGER,
  -- 1 Ball(s)
  swingsOneAndZero INTEGER,
  swingsOneAndOne INTEGER,
  swingsOneAndTwo INTEGER,
  -- 2 Ball(s)
  swingsTwoAndZero INTEGER,
  swingsTwoAndOne INTEGER,
  swingsTwoAndTwo INTEGER,
  -- 3 Ball(s)
  swingsThreeAndZero INTEGER,
  swingsThreeAndOne INTEGER,
  swingsThreeAndTwo INTEGER,
  -- Trajectories
  flyBalls INTEGER,
  groundBalls INTEGER,
  lineDrives INTEGER,
  popUps INTEGER,
  groundBunts INTEGER,
  popupBunts INTEGER,
  lineDriveBunts INTEGER
);

ALTER TABLE game_player_split_stats ADD INDEX(gamePk, battingTeamId, batterId);
ALTER TABLE game_player_split_stats ADD INDEX(gamePk, pitchingTeamId, pitcherId);
