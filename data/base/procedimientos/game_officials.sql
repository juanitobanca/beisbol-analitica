USE baseball;

DROP PROCEDURE game_officials;

DELIMITER //

CREATE PROCEDURE game_officials()
BEGIN

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

COMMIT;

END //

DELIMITER ;
