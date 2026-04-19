-- Procedure: actions
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
  "index" playIndex,
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
UPDATE actions
SET pitchingTeamId = (SELECT q.pitchingTeamId FROM atbats q WHERE actions.gamePk = q.gamePk AND actions.atBatIndex = q.atBatIndex),
    battingTeamId  = (SELECT q.battingTeamId  FROM atbats q WHERE actions.gamePk = q.gamePk AND actions.atBatIndex = q.atBatIndex),
    inning         = (SELECT q.inning         FROM atbats q WHERE actions.gamePk = q.gamePk AND actions.atBatIndex = q.atBatIndex),
    halfInning     = (SELECT q.halfInning     FROM atbats q WHERE actions.gamePk = q.gamePk AND actions.atBatIndex = q.atBatIndex)
WHERE (pitchingTeamId IS NULL OR battingTeamId IS NULL)
AND EXISTS (SELECT 1 FROM atbats q WHERE actions.gamePk = q.gamePk AND actions.atBatIndex = q.atBatIndex);
