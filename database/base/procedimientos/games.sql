-- Procedure: games
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
    SELECT DISTINCT
      gamePk,
      gameType,
      CASE WHEN majorLeague = 'WBC' THEN
           CAST(SUBSTR(CAST(season AS TEXT),1,4) AS INTEGER )
           WHEN majorLeague = 'LMB' THEN
           CAST(REPLACE(season, ".", "") AS INTEGER)
           ELSE CAST( season AS INTEGER)
      END seasonId,
      date(SUBSTR(gameDate, 1, 10)) gameDate,
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

UPDATE games
SET weather    = (SELECT gi.weather FROM stg_box_info gi WHERE games.gamePk = gi.gamePk),
    wind       = (SELECT gi.wind FROM stg_box_info gi WHERE games.gamePk = gi.gamePk),
    attendance = (SELECT CAST(REPLACE(REPLACE(gi.attendance,',',''),'.','') AS INTEGER) FROM stg_box_info gi WHERE games.gamePk = gi.gamePk)
WHERE EXISTS (SELECT 1 FROM stg_box_info gi WHERE games.gamePk = gi.gamePk);
