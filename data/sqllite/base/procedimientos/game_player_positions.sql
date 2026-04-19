-- Procedure: game_player_positions
INSERT INTO game_player_positions(
    gamePk,
    teamId,
    teamType,
    playerId,
    positionAbbrev
  )
SELECT DISTINCT
  gamePk,
  teamId,
  teamType,
  playerId,
  abbreviation positionAbbrev
FROM stg_box_player_game_positions
WHERE
  1 = 1
  AND (gamePk, teamId, playerId) NOT IN (
    SELECT
      gamePk,
      teamId,
      playerId
    FROM game_player_positions
  );
