USE baseball;

DROP PROCEDURE games;

DELIMITER //

CREATE PROCEDURE games()
BEGIN

INSERT INTO games(
    gamePk,
    gameType,
    seasonId,
    gameDate,
    isTie,
    gameNumber,
    doubleHeader,
    dayNight,
    scheduledInnings,
    gamesInSeries,
    seriesDescription,
    ifNecessaryDescription,
    gameId,
    abstractGameState,
    codedGameState,
    detailedState,
    awayWins,
    awayLosses,
    awayPct,
    awayScore,
    awayTeamId,
    awayIsWinner,
    homeWins,
    homeLosses,
    homePct,
    homeScore,
    homeTeamId,
    homeIsWinner,
    venueId,
    homeTeamName,
    awayTeamName,
    venueName,
    majorLeague,
    majorLeagueId,
    gameType2
  )
    SELECT
      gamePk,
      gameType,
      CASE WHEN majorLeague = 'WBC' THEN
           CAST(SUBSTR(CAST(season AS CHAR(30) ),1,4) AS DOUBLE )
           ELSE season
      END seasonId,
      str_to_date(SUBSTR(gameDate, 1, 10), '%Y-%m-%d') gameDate,
      isTie,
      gameNumber,
      doubleHeader,
      dayNight,
      scheduledInnings,
      gamesInSeries,
      seriesDescription,
      ifNecessaryDescription,
      gameId,
      abstractGameState,
      codedGameState,
      detailedState,
      awayWins,
      awayLosses,
      awayPct,
      awayScore,
      awayId AS awayTeamId,
      awayIsWinner,
      homeWins,
      homeLosses,
      homePct,
      homeScore,
      homeId AS homeTeamId,
      homeIsWinner,
      venueId,
      homeName homeTeamName,
      awayName awayTeamName,
      venueName,
      majorLeague,
      majorLeagueId,
      CASE
        WHEN gameType IN ('F', 'D', 'L', 'W') THEN 'PS'
        WHEN gameType = 'R' THEN 'RS'
        ELSE gameType
      END gameType2
    FROM stg_game_context
WHERE
  1 = 1
  AND gamePk NOT IN (
    SELECT
      gamePk
    FROM games
  )
  AND gamePk IS NOT NULL;

UPDATE games g
INNER JOIN stg_box_info  gi
ON g.gamePk   = gi.gamePk
SET g.weather = gi.weather
,   g.wind    = gi.wind
,   g.attendance  = CAST(REPLACE(REPLACE(gi.attendance,',',''),'.','') AS UNSIGNED);

COMMIT;

END //

DELIMITER ;
