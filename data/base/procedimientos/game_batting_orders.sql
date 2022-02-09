USE baseball;

DROP PROCEDURE game_batting_orders;

DELIMITER //

CREATE PROCEDURE game_batting_orders()
BEGIN

INSERT INTO game_batting_orders(
    gamePk,
    teamId,
    playerId,
    battingOrder
  )
SELECT DISTINCT
  gamePk,
  teamId,
  playerId,
  /* Data issue, MLB */
  battingOrder
FROM stg_box_team_batting_order
WHERE
  gamePk NOT IN (
    SELECT
      gamePk
    FROM game_batting_orders
  )
AND battingOrder IS NOT NULL
AND gamePk IS NOT NULL;

COMMIT;

END //

DELIMITER ;
