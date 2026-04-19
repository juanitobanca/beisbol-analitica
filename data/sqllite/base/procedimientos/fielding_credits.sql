-- Procedure: fielding_credits
INSERT INTO fielding_credits(
    gamePk,
    atBatIndex,
    playerId,
    positionAbbrev,
    credit
  )
SELECT DISTINCT
  gamePk,
  atBatIndex,
  playerId,
  abbreviation positionAbbrev,
  credit
FROM stg_play_credit
WHERE
  1 = 1
  AND (gamePk, atBatIndex) NOT IN (
    SELECT
      gamePk,
      atBatIndex
    FROM fielding_credits
  );
