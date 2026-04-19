-- Procedure: runners
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
      CAST(responsiblePitcherId AS INTEGER) responsiblePitcherId,
      runnerId,
      startBase,
      endBase,
      isOut,
      outBase,
      CAST(outNumber AS INTEGER) outNumber,
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

UPDATE runners
SET pitchingTeamId = (SELECT q.pitchingTeamId FROM atbats q WHERE runners.gamePk = q.gamePk AND runners.atBatIndex = q.atBatIndex),
    battingTeamId  = (SELECT q.battingTeamId  FROM atbats q WHERE runners.gamePk = q.gamePk AND runners.atBatIndex = q.atBatIndex),
    inning         = (SELECT q.inning         FROM atbats q WHERE runners.gamePk = q.gamePk AND runners.atBatIndex = q.atBatIndex),
    halfInning     = (SELECT q.halfInning     FROM atbats q WHERE runners.gamePk = q.gamePk AND runners.atBatIndex = q.atBatIndex)
WHERE (pitchingTeamId IS NULL OR battingTeamId IS NULL)
AND EXISTS (SELECT 1 FROM atbats q WHERE runners.gamePk = q.gamePk AND runners.atBatIndex = q.atBatIndex);
