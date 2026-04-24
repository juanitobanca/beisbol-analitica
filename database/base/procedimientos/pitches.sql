-- Procedure: pitches
INSERT INTO pitches(
    gamePk,
    atBatIndex,
    playIndex,
    pitchNumber,
    endBalls,
    endStrikes,
    callCode,
    callDescription,
    callDescription2,
    code,
    isInPlay,
    isStrike,
    isBall,
    typeCode,
    typeDescription,
    hasReview,
    runnerGoing,
    strikeZoneTop,
    strikeZoneBottom,
    x,
    y,
    x0,
    y0,
    trajectory,
    hardness,
    location,
    coordX,
    coordY
  )
SELECT DISTINCT
  gamePk,
  atBatIndex,
  "index" playIndex,
  pitchNumber,
  balls AS endBalls,
  strikes AS endStrikes,
  callCode,
  callDescription,
  description callDescription2,
  code,
  isInPlay,
  isStrike,
  isBall,
  typeCode,
  typeDescription,
  hasReview,
  runnerGoing,
  strikeZoneTop,
  strikeZoneBottom,
  x,
  y,
  x0,
  y0,
  trajectory,
  hardness,
  location,
  coordX,
  -1 * ( coordY - 250 ) coordY
FROM stg_play_pitch
WHERE
  1 = 1
  AND (gamePk, atBatIndex) NOT IN (
    SELECT
      gamePk,
      atBatIndex
    FROM pitches
  );

-- Update batting/pitching ids
UPDATE pitches
SET pitchingTeamId = (SELECT q.pitchingTeamId FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    battingTeamId  = (SELECT q.battingTeamId  FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    inning         = (SELECT q.inning         FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    halfInning     = (SELECT q.halfInning     FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    batterId       = (SELECT q.batterId       FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    pitcherId      = (SELECT q.pitcherId      FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    pitchHand      = (SELECT q.pitchHand      FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    batSide        = (SELECT q.batSide        FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex),
    menOnBase      = (SELECT q.menOnBase      FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex)
WHERE (pitchingTeamId IS NULL OR battingTeamId IS NULL)
AND EXISTS (SELECT 1 FROM atbats q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex);

-- LEFT JOIN: set startBalls/startStrikes from previous pitch, defaulting to 0
UPDATE pitches
SET startBalls   = COALESCE((SELECT q.endBalls FROM pitches q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex AND pitches.pitchNumber - 1 = q.pitchNumber), 0),
    startStrikes = COALESCE((SELECT q.endStrikes FROM pitches q WHERE pitches.gamePk = q.gamePk AND pitches.atBatIndex = q.atBatIndex AND pitches.pitchNumber - 1 = q.pitchNumber), 0)
WHERE (startBalls IS NULL OR startStrikes IS NULL);

UPDATE pitches
SET
HM4 = CASE
    WHEN CoordY <= 43 THEN 'FHP'
    WHEN CoordX >= 125 AND CoordY >= 2.41 * CoordX - 258.25 THEN 'RF1'
    WHEN CoordX >= 125 AND CoordY >= CoordX-82 THEN 'RF2'
    WHEN CoordX >= 125 THEN 'FRF'
    WHEN CoordX <= 125 AND CoordY >= -2.41 * CoordX + 344.25 THEN 'LF1'
    WHEN CoordX <= 125 AND CoordY >= -CoordX + 169  THEN 'LF2'
    WHEN CoordX <= 125 THEN 'FLF'
  END,
HM8 = CASE
    WHEN CoordY <= 43 THEN 'FHP'
    WHEN CoordX >= 125 AND CoordY >= 5.03 * CoordX - 585.75 THEN 'RF1'
    WHEN CoordX >= 125 AND CoordY >= 2.41 * CoordX - 258.25 THEN 'RF2'
    WHEN CoordX >= 125 AND CoordY >= 1.5 * CoordX - 144.5 THEN 'RF3'
    WHEN CoordX >= 125 AND CoordY >= CoordX-82 THEN 'RF4'
    WHEN CoordX >= 125 THEN 'FRF'
    WHEN CoordX <= 125 AND CoordY >= -5.03 * CoordX + 671.75 THEN 'LF1'
    WHEN CoordX <= 125 AND CoordY >= -2.41 * CoordX + 344.25 THEN 'LF2'
    WHEN CoordX <= 125 AND CoordY >= -1.5 * CoordX + 230.5 THEN 'LF3'
    WHEN CoordX <= 125 AND CoordY >= -CoordX + 169  THEN 'LF4'
    WHEN CoordX <= 125 THEN 'FLF'
  END;
