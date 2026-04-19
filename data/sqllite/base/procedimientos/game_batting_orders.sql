-- Procedure: game_batting_orders
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
