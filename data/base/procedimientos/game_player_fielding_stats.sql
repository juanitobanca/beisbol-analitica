-- Procedure: game_player_fielding_stats
INSERT INTO game_player_fielding_stats(
    gamePk,
    teamId,
    teamType,
    playerId,
    assists,
    caughtStealing,
    chances,
    errors,
    passedBall,
    pickoffs,
    putOuts,
    stolenBases
  )
SELECT DISTINCT
  gamePk,
  teamId,
  teamType,
  playerId,
  COALESCE(CAST(assists AS INTEGER), 0) assists,
  COALESCE(CAST(caughtStealing AS INTEGER), 0) caughtStealing,
  COALESCE(CAST(chances AS INTEGER), 0) chances,
  COALESCE(CAST(errors AS INTEGER), 0) errors,
  COALESCE(CAST(passedBall AS INTEGER), 0) passedBall,
  COALESCE(CAST(pickoffs AS INTEGER), 0) pickoffs,
  COALESCE(CAST(putOuts AS INTEGER), 0) putOuts,
  COALESCE(CAST(stolenBases AS INTEGER), 0) stolenBases
FROM stg_box_player_fielding
WHERE
  1 = 1
  AND (
    COALESCE(CAST(assists AS INTEGER), 0) > 0
    OR COALESCE(CAST(caughtStealing AS INTEGER), 0) > 0
    OR COALESCE(CAST(chances AS INTEGER), 0) > 0
    OR COALESCE(CAST(errors AS INTEGER), 0) > 0
    OR COALESCE(CAST(passedBall AS INTEGER), 0) > 0
    OR COALESCE(CAST(pickoffs AS INTEGER), 0) > 0
    OR COALESCE(CAST(putOuts AS INTEGER), 0) > 0
    OR COALESCE(CAST(stolenBases AS INTEGER), 0) > 0
  )
  AND (gamePk, teamId, playerId) NOT IN (
    SELECT
      gamePk,
      teamId,
      playerId
    FROM game_player_fielding_stats
  );
