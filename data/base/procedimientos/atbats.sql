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
SELECT DISTINCT
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

-- Stats from pitching
UPDATE atbats a
INNER JOIN
(
    SELECT
      gamePk,
      atBatIndex,
      COUNT(1) pitches
    FROM pitches
    WHERE ( gamePk, atBatIndex ) NOT IN ( -- Only update deltas.
                                          SELECT gamePk, atBatIndex
                                          FROM atbats
                                          WHERE pitches IS NOT NULL
                                        )
    GROUP BY 1,2
) p
ON a.gamePk = p.gamePk
AND a.atBatIndex = p.atBatIndex
SET a.pitches = p.pitches;

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
    HM4,
    HM8
  FROM pitches
) p
  ON (
    a.gamePk = p.gamePk
    AND a.atBatIndex = p.atBatIndex
    AND a.pitches = p.pitchNumber
  )
  SET a.HM4 = p.HM4
  ,   a.HM8 = p.HM8
  WHERE 1 = 1
  AND   a.HM8 IS NULL;

COMMIT;

END //

DELIMITER ;
