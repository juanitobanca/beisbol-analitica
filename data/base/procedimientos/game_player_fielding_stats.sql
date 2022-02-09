USE baseball;

DROP PROCEDURE game_player_fielding_stats;

DELIMITER //

CREATE PROCEDURE game_player_fielding_stats()
BEGIN

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
  COALESCE(CAST(assists AS UNSIGNED), 0) assists,
  COALESCE(CAST(caughtStealing AS UNSIGNED), 0) caughtStealing,
  COALESCE(CAST(chances AS UNSIGNED), 0) chances,
  COALESCE(CAST(errors AS UNSIGNED), 0) errors,
  COALESCE(CAST(passedBall AS UNSIGNED), 0) passedBall,
  COALESCE(CAST(pickoffs AS UNSIGNED), 0) pickoffs,
  COALESCE(CAST(putOuts AS UNSIGNED), 0) putOuts,
  COALESCE(CAST(stolenBases AS UNSIGNED), 0) stolenBases
FROM stg_box_player_fielding
WHERE
  1 = 1
  AND (
    COALESCE(CAST(assists AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(caughtStealing AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(chances AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(errors AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(passedBall AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(pickoffs AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(putOuts AS UNSIGNED), 0) > 0
    OR COALESCE(CAST(stolenBases AS UNSIGNED), 0) > 0
  )
  AND (gamePk, teamId, playerId) NOT IN (
    SELECT
      gamePk,
      teamId,
      playerId
    FROM game_player_fielding_stats
  );

COMMIT;

END //

DELIMITER ;
