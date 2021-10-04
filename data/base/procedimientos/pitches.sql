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
    coordY
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
    pitcherId,
    batStand,
    pitchHand
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
  ,   p.pitchHand      = q.pitchHand
  ,   p.batStand       = q.batStand
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

COMMIT;

END //

DELIMITER ;
