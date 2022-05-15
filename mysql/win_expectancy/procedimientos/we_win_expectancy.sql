USE baseball;

DROP PROCEDURE we_win_expectancy;

DELIMITER //

CREATE PROCEDURE we_win_expectancy()
BEGIN

INSERT INTO we_win_expectancy (
    groupingId,
    groupingDescription,
    majorLeagueId,
    seasonId,
    inning,
    gameType2,
    menOnBase,
    outs,
    score,
    games,
    wins,
    losses
  )
  WITH pbp AS (
    -- Obtener probabailidades.
    -- Outs <= 2
SELECT
  pbp.gamePk,
  pbp.majorLeagueId,
  pbp.seasonId,
  pbp.inning,
  pbp.gameType2,
  pbp.menOnBaseBeforePlay AS menOnBase,
  pbp.outsBeforePlay AS outs,
  CASE
    WHEN homeTeamId = battingTeamId AND battingTeamScore - pitchingTeamScore < 0 THEN 'LOSING'
    WHEN homeTeamId = battingTeamId AND battingTeamScore - pitchingTeamScore > 0 THEN 'WINNING'
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScore - battingTeamScore < 0 THEN 'LOSING'
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScore - battingTeamScore > 0 THEN 'WINNING'
    ELSE 'TIE'
  END score,

  CASE
    WHEN homeTeamId = battingTeamId AND battingTeamScoreEndGame > pitchingTeamScoreEndGame THEN 1
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScoreEndGame > battingTeamScoreEndGame THEN 1
    ELSE 0
  END wins,

  CASE
    WHEN homeTeamId = battingTeamId AND battingTeamScoreEndGame < pitchingTeamScoreEndGame THEN 1
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScoreEndGame < battingTeamScoreEndGame THEN 1
    ELSE 0
  END losses
FROM rem_play_by_play pbp
INNER JOIN games g
  ON pbp.gamePk = g.gamePk
WHERE
  pbp.gameType2 = 'RS'
  AND battingTeamScoreEndGame != pitchingTeamScoreEndGame

    UNION ALL

  -- Outs = 3
SELECT
  pbp.gamePk,
  pbp.majorLeagueId,
  pbp.seasonId,
  pbp.inning,
  pbp.gameType2,
  'Empty' AS menOnBase,
  pbp.outsAfterPlay AS outs,
  CASE
    WHEN homeTeamId = battingTeamId AND battingTeamScore - pitchingTeamScore < 0 THEN 'LOSING'
    WHEN homeTeamId = battingTeamId AND battingTeamScore - pitchingTeamScore > 0 THEN 'WINNING'
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScore - battingTeamScore < 0 THEN 'LOSING'
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScore - battingTeamScore > 0 THEN 'WINNING'
    ELSE 'TIE'
  END score,

  CASE
    WHEN homeTeamId = battingTeamId AND battingTeamScoreEndGame > pitchingTeamScoreEndGame THEN 1
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScoreEndGame > battingTeamScoreEndGame THEN 1
    ELSE 0
  END wins,

  CASE
    WHEN homeTeamId = battingTeamId AND battingTeamScoreEndGame < pitchingTeamScoreEndGame THEN 1
    WHEN homeTeamId = pitchingTeamId AND pitchingTeamScoreEndGame < battingTeamScoreEndGame THEN 1
    ELSE 0
  END losses
FROM rem_play_by_play pbp
INNER JOIN games g
  ON pbp.gamePk = g.gamePk
WHERE

        pbp.gameType2 = 'RS'
        AND battingTeamScoreEndGame != pitchingTeamScoreEndGame
        AND outsAfterPlay = 3
  )
SELECT
  agg_grouping_id('majorLeagueId,seasonId,inning,gameType2,menOnBase,outs') groupingId,
  agg_grouping_description('majorLeagueId,seasonId,inning,gameType2,menOnBase,outs') groupingDescription,
  majorLeagueId,
  seasonId,
  inning,
  gameType2,
  menOnBase,
  outs,
  score,
  COUNT(1) AS games,
  SUM(wins) AS wins,
  SUM(losses) AS losses
FROM pbp
GROUP BY
  1, 2, 3, 4, 5, 6, 7, 8, 9;

UPDATE
  we_win_expectancy
  SET winExpectancy = wins / games;

COMMIT;

END //

DELIMITER ;
