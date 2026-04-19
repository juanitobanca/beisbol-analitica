-- Procedure: game_officials
INSERT INTO game_officials(
    gamePk,
    officialId,
    position
  )
    SELECT DISTINCT
      gamePk,
      officialId,
      position
    FROM stg_box_officials
WHERE
  1 = 1
  AND gamePk NOT IN (
    SELECT
      gamePk
    FROM game_officials
  )
  AND gamePk IS NOT NULL;
