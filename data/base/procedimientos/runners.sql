USE baseball;

DROP PROCEDURE runners;

DELIMITER //

CREATE PROCEDURE runners()
BEGIN

INSERT INTO runners(
    gamePk,
    atBatIndex,
    playIndex,
    event,
    eventType,
    isScoringPlay,
    movementReason,
    rbi,
    responsiblePitcherId,
    runnerId,
    startBase,
    endBase,
    isOut,
    outBase,
    outNumber,
    earned,
    teamUnearned
  )
    SELECT DISTINCT
      gamePk,
      atBatIndex,
      playIndex,
      event,
      eventType,
      isScoringEvent isScoringPlay,
      movementReason,
      rbi,
      CAST(responsiblePitcherId AS UNSIGNED) responsiblePitcherId,
      runnerId,
      startBase,
      endBase,
      isOut,
      outBase,
      CAST(outNumber AS UNSIGNED) outNumber,
      earned,
      teamUnearned
    FROM stg_play_runner
    WHERE
      1 = 1
      AND COALESCE(outNumber, 0) != -1
  AND (gamePk, atBatIndex) NOT IN (
    SELECT
      gamePk,
      atBatIndex
    FROM runners
  );

UPDATE
  runners p
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
