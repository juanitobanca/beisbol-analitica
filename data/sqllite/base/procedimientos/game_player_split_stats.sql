-- Procedure: game_player_split_stats
INSERT INTO game_player_split_stats(
    gamePk,
    atBatIndex,
    battingTeamId,
    batterId,
    batSide,
    pitchingTeamId,
    pitcherId,
    pitchHand,
    menOnBase,
    balks,
    batterInterferences,
    bunts,
    catcherInterferences,
    doubles,
    fanInterferences,
    fieldErrors,
    fieldersChoice,
    flyouts,
    forceOuts,
    groundedIntoDoublePlays,
    groundOuts,
    hitByPitch,
    homeRuns,
    intentionalWalks,
    lineOuts,
    passedBalls,
    popOuts,
    runsBattedIn,
    sacBunts,
    sacFlies,
    singles,
    strikeOuts,
    triples,
    triplePlays,
    walks,
    wildPitches
  )
SELECT
  gamePk,
  atBatIndex,
  battingTeamId,
  batterId,
  batSide,
  pitchingTeamId,
  pitcherId,
  pitchHand,
  menOnBase,
  SUM(CASE WHEN event = 'Balk' THEN 1 ELSE 0 END) AS balks,
  SUM(CASE WHEN event = 'Batter Interference' THEN 1 ELSE 0 END) AS batterInterferences,
  SUM(CASE WHEN event IN ('Bunt Groundout', 'Bunt Lineout', 'Bunt Pop Out') THEN 1 ELSE 0 END) AS bunts,
  SUM(CASE WHEN event = 'Catcher Interference' THEN 1 ELSE 0 END) AS catcherInterferences,
  SUM(CASE WHEN event = 'Double' THEN 1 ELSE 0 END) AS doubles,
  SUM(CASE WHEN event = 'Fan Interference' THEN 1 ELSE 0 END) AS fanInterferences,
  SUM(CASE WHEN event = 'Field Error' THEN 1 ELSE 0 END) fieldErrors,
  SUM(CASE WHEN event IN ('Fielders Choice', 'Fielders Choice Out') THEN 1 ELSE 0 END) AS fieldersChoice,
  SUM(CASE WHEN event = 'Flyout' THEN 1 ELSE 0 END) AS flyouts,
  SUM(CASE WHEN event = 'Forceout' THEN 1 ELSE 0 END) AS forceOuts,
  SUM(CASE WHEN event IN ('Double Play', 'Grounded Into DP') THEN 1 ELSE 0 END) AS groundedIntoDoublePlays,
  SUM(CASE WHEN event = 'Groundout' THEN 1 ELSE 0 END) AS groundOuts,
  SUM(CASE WHEN event = 'Hit By Pitch' THEN 1 ELSE 0 END) AS hitByPitch,
  SUM(CASE WHEN event = 'Home Run' THEN 1 ELSE 0 END) AS homeRuns,
  SUM(CASE WHEN event = 'Intent Walk' THEN 1 ELSE 0 END) AS intentionalWalks,
  SUM(CASE WHEN event = 'Lineout' THEN 1 ELSE 0 END) AS lineOuts,
  SUM(CASE WHEN event = 'Passed Ball' THEN 1 ELSE 0 END) AS passedBalls,
  SUM(CASE WHEN event = 'Pop Out' THEN 1 ELSE 0 END) AS popOuts,
  SUM(rbi) AS runsBattedIn,
  SUM(CASE WHEN event IN ('Sac Bunt', 'Sac Bunt Double Play') THEN 1 ELSE 0 END) AS sacBunts,
  SUM(CASE WHEN event IN ('Sac Fly', 'Sac Fly Double Play') THEN 1 ELSE 0 END) AS sacFlies,
  SUM(CASE WHEN event = 'Single' THEN 1 ELSE 0 END) AS singles,
  SUM(
    CASE WHEN event IN ('Strikeout', 'Strikeout Double Play', 'Strikeout Triple Play') THEN 1 ELSE 0 END
  ) AS strikeOuts,
  SUM(CASE WHEN event = 'Triple' THEN 1 ELSE 0 END) AS triples,
  SUM(CASE WHEN event = 'Triple Play' THEN 1 ELSE 0 END) AS triplePlays,
  SUM(CASE WHEN event = 'Walk' THEN 1 ELSE 0 END) AS walks,
  SUM(CASE WHEN event = 'Wild Pitch' THEN 1 ELSE 0 END) AS wildPitches
FROM atbats
WHERE ( gamePk, atBatIndex ) NOT IN ( SELECT gamePk, atBatIndex
                                      FROM game_player_split_stats
                                    )
GROUP BY
  1, 2, 3, 4, 5, 6, 7, 8, 9;


-- Stats from pitching
UPDATE game_player_split_stats
SET balls              = (SELECT SUM(CASE WHEN callCode IN ('B', 'I', 'P', 'V', '*B') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    ballsPitchOut      = (SELECT SUM(CASE WHEN callCode IN ('P') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    ballsInDirt        = (SELECT SUM(CASE WHEN callCode IN ('*B') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    intentBalls        = (SELECT SUM(CASE WHEN callCode IN ('I') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    fouls              = (SELECT SUM(CASE WHEN callCode IN ('F', 'L', 'O', 'R', 'T') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    foulBunts          = (SELECT SUM(CASE WHEN callCode IN ('L') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    foulTips           = (SELECT SUM(CASE WHEN callCode IN ('T','O') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    foulPitchOuts      = (SELECT SUM(CASE WHEN callCode IN ('R') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    hitIntoPlay        = (SELECT SUM(CASE WHEN callCode IN ('D','E','J','X','Y','Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    pitches            = (SELECT COUNT(1) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    pitchOuts          = (SELECT SUM(CASE WHEN callCode IN ('J','P','Q','R','Y','Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    strikes            = (SELECT SUM(CASE WHEN callCode IN ('A', 'C', 'K', 'M', 'Q', 'S', 'W') OR callDescription2 IN ('Strike - Foul', 'Strike - Foul Bunt', 'Strike - Foul Tip') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    strikesCalled      = (SELECT SUM(CASE WHEN callCode IN ('C') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    strikesPitchOuts   = (SELECT SUM(CASE WHEN callCode IN ('Q') OR callDescription2 IN ('Strike - Foul on Pitchout') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    missedBunts        = (SELECT SUM(CASE WHEN callCode IN ('M') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingAndMissStrikes = (SELECT SUM(CASE WHEN callCode IN ('Q', 'S', 'W') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsPitchOuts    = (SELECT SUM(CASE WHEN callCode IN ('J','Q','R','Y','Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swings             = (SELECT SUM(CASE WHEN callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    -- Swings Per Ball and Strikes
    -- 0 Ball(s)
    swingsZeroAndZero  = (SELECT SUM(CASE WHEN startBalls = 0 AND startStrikes = 0 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsZeroAndOne   = (SELECT SUM(CASE WHEN startBalls = 0 AND startStrikes = 1 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsZeroAndTwo   = (SELECT SUM(CASE WHEN startBalls = 0 AND startStrikes = 2 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    -- 1 Ball(s)
    swingsOneAndZero   = (SELECT SUM(CASE WHEN startBalls = 1 AND startStrikes = 0 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsOneAndOne    = (SELECT SUM(CASE WHEN startBalls = 1 AND startStrikes = 1 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsOneAndTwo    = (SELECT SUM(CASE WHEN startBalls = 1 AND startStrikes = 2 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    -- 2 Ball(s)
    swingsTwoAndZero   = (SELECT SUM(CASE WHEN startBalls = 2 AND startStrikes = 0 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsTwoAndOne    = (SELECT SUM(CASE WHEN startBalls = 2 AND startStrikes = 1 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsTwoAndTwo    = (SELECT SUM(CASE WHEN startBalls = 2 AND startStrikes = 2 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    -- 3 Ball(s)
    swingsThreeAndZero = (SELECT SUM(CASE WHEN startBalls = 3 AND startStrikes = 0 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsThreeAndOne  = (SELECT SUM(CASE WHEN startBalls = 3 AND startStrikes = 1 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    swingsThreeAndTwo  = (SELECT SUM(CASE WHEN startBalls = 3 AND startStrikes = 2 AND callCode IN ('D', 'E', 'F', 'J', 'Q', 'R', 'S', 'T', 'W', 'X', 'Y', 'Z') THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    -- Trajectories
    flyBalls           = (SELECT SUM(CASE WHEN trajectory = 'fly_ball' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    groundBalls        = (SELECT SUM(CASE WHEN trajectory = 'ground_ball' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    lineDrives         = (SELECT SUM(CASE WHEN trajectory = 'line_drive' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    popUps             = (SELECT SUM(CASE WHEN trajectory = 'popup' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    groundBunts        = (SELECT SUM(CASE WHEN trajectory = 'bunt_grounder' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    popupBunts         = (SELECT SUM(CASE WHEN trajectory = 'bunt_popup' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex),
    lineDriveBunts     = (SELECT SUM(CASE WHEN trajectory = 'bunt_line_drive' THEN 1 ELSE 0 END) FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex)
WHERE game_player_split_stats.balls IS NULL
AND EXISTS (SELECT 1 FROM pitches p WHERE game_player_split_stats.gamePk = p.gamePk AND game_player_split_stats.atBatIndex = p.atBatIndex);
