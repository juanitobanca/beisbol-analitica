USE baseball;

DROP PROCEDURE actions;

DELIMITER //

CREATE PROCEDURE actions()
BEGIN

INSERT INTO actions(
    gamePk,
    atBatIndex,
    playIndex,
    playerId,
    endOuts,
    endBalls,
    endStrikes,
    hasReview,
    isScoringPlay,
    awayScore,
    homeScore,
    event,
    eventType,
    battingOrder,
    positionAbbrev,
    injuryType,
    description
  )
SELECT DISTINCT
  gamePk,
  atBatIndex,
  `index` playIndex,
  playerId,
  outs AS endOuts,
  balls AS endBalls,
  strikes AS endStrikes,
  hasReview,
  isScoringPlay,
  awayScore,
  homeScore,
  event,
  eventType,
  battingOrder,
  abbreviation positionAbbrev,
  injuryType,
  description
FROM stg_play_action
WHERE
  1 = 1
  AND (gamePk, atBatIndex) NOT IN (
    SELECT
      gamePk,
      atBatIndex
    FROM actions
  );

-- actions
UPDATE
  actions p
INNER JOIN (
  SELECT
    gamePk,
    atBatIndex,
    inning,
    halfInning,
    pitchingTeamId,
    battingTeamId
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
  Where 1 = 1
  And   ( p.pitchingTeamId Is Null Or p.battingTeamId Is Null );

COMMIT;

END //

DELIMITER ;
