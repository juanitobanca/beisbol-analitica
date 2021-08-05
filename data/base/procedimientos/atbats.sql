USE baseball;

DROP PROCEDURE atbats;

DELIMITER //

CREATE PROCEDURE atbats()
BEGIN

INSERT INTO atbats(
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    endOuts,
    endBalls,
    endStrikes,
    batterId,
    pitcherId,
    hasOut,
    hasReview,
    isScoringPlay,
    rbi,
    awayScore,
    homeScore,
    event,
    eventType,
    batSide,
    pitchHand,
    menOnBase,
    description
  )
SELECT
  gamePk,
  inning,
  halfInning,
  atBatIndex,
  outs AS endOuts,
  balls AS endBalls,
  strikes AS endStrikes,
  batterId,
  pitcherId,
  hasOut,
  hasReview,
  isScoringPlay,
  rbi,
  awayScore,
  homeScore,
  event,
  eventType,
  batterSideCode AS batSide,
  pitcherHandCode AS pitchHand,
  menOnBase,
  description
FROM stg_play_atbat
WHERE
  1 = 1
  AND (gamePk, atBatIndex) NOT IN (
    SELECT
      gamePk,
      atBatIndex
    FROM atbats
  );

-- Update batting/pitching teams
UPDATE
  atbats a
INNER JOIN (
  SELECT
    gamePk,
    homeTeamId,
    awayTeamId
  FROM games g
) q
  ON (a.gamePk = q.gamePk)
  SET a.pitchingTeamId = If( a.halfInning = 'top', homeTeamId, awayTeamId )
  ,   a.battingTeamId  = If( a.halfInning = 'top', awayTeamId, homeTeamId )
  Where 1 = 1
  And   ( pitchingTeamId Is Null Or battingTeamId Is Null );

-- Update Where the BIP landed ( HM4, HM8 )
UPDATE
  atbats a
INNER JOIN (
  SELECT
    gamePk,
    atBatIndex,
    pitchNumber,
    heatMapFour,
    heatMapEight
  FROM pitches
) p
  ON (
    a.gamePk = p.gamePk
    AND a.atBatIndex = p.atBatIndex
    AND a.pitches = p.pitchNumber
  )
  SET a.heatMapFour = p.heatMapFour
  ,   a.heatMapEight = p.heatMapEight
  WHERE 1 = 1
  AND   a.heatMapEight IS NULL;

COMMIT;

END //

DELIMITER ;
