USE baseball;

DROP PROCEDURE pitches;

DELIMITER //

CREATE PROCEDURE pitches()
BEGIN

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
    coordY,
    heatMapFour,
    heatMapEight
  )
SELECT
  gamePk,
  atBatIndex,
  `index` playIndex,
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
  coordY,
  CASE
    WHEN y <= 43 THEN 'FHP'
    WHEN x >= 125 AND y >= 2.41 * x - 258.25 THEN 'RF1'
    WHEN x >= 125 AND y >= x-82 THEN 'RF2'
    WHEN x >= 125 THEN 'FRF'
    WHEN x <= 125 AND y >= -2.41 * x + 344.25 THEN 'LF1'
    WHEN x <= 125 AND y >= -x + 169  THEN 'LF2'
    WHEN x <= 125 THEN 'FLF'
  END heatMapFour,
  CASE
    WHEN y <= 43 THEN 'FHP'
    WHEN x >= 125 AND y >= 5.03 * x - 585.75 THEN 'RF1'
    WHEN x >= 125 AND y >= 2.41 * x - 258.25 THEN 'RF2'
    WHEN x >= 125 AND y >= 1.5 * x - 144.5 THEN 'RF3'
    WHEN x >= 125 AND y >= x-82 THEN 'RF4'
    WHEN x >= 125 THEN 'FRF'
    WHEN x <= 125 AND y >= -5.03 * x + 671.75 THEN 'LF1'
    WHEN x <= 125 AND y >= -2.41 * x + 344.25 THEN 'LF2'
    WHEN x <= 125 AND y >= -1.5 * x + 230.5 THEN 'LF3'
    WHEN x <= 125 AND y >= -x + 169  THEN 'LF4'
    WHEN x <= 125 THEN 'FLF'
  END heatMapEight
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
UPDATE
  pitches p
INNER JOIN (
  SELECT
    gamePk,
    atBatIndex,
    inning,
    halfInning,
    pitchingTeamId,
    battingTeamId,
    batterId,
    pitcherId
  FROM atbats
  WHERE
    1 = 1
) q
  ON (
    p.gamePk = q.gamePk
    AND p.atBatIndex = q.atBatIndex
  )
  SET p.pitchingTeamId = q.pitchingTeamId
  ,   p.battingTeamId  = q.battingTeamId
  ,   p.inning         = q.inning
  ,   p.halfInning     = q.halfInning
  ,   p.batterId       = q.batterId
  ,   p.pitcherId      = q.pitcherId
  Where 1 = 1
  And   ( p.pitchingTeamId Is Null Or p.battingTeamId Is Null );

UPDATE
  pitches p
LEFT JOIN (
  SELECT
    gamePk,
    atBatIndex,
    pitchNumber,
    endBalls,
    endStrikes
  FROM pitches
  WHERE
    1 = 1
) q
  ON (
    p.gamePk = q.gamePk
    AND p.atBatIndex = q.atBatIndex
    AND p.pitchNumber - 1 = q.pitchNumber
  )
  SET  p.startBalls   = Coalesce( q.endBalls, 0 )
  ,    p.startStrikes = Coalesce( q.endStrikes, 0 )
  Where 1 = 1
  And   ( p.startBalls Is Null Or p.startStrikes Is Null );

COMMIT;

END //

DELIMITER ;
