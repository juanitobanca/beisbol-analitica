USE baseball;

DROP PROCEDURE game_player_pitching_stats;

DELIMITER //

CREATE PROCEDURE game_player_pitching_stats()
BEGIN

INSERT INTO game_player_pitching_stats(
    gamePk,
    teamId,
    teamType,
    playerId,
    airOuts,
    atBats,
    balls,
    walks,
    battersFaced,
    blownSaves,
    catchersInterference,
    caughtStealing,
    completeGames,
    doubles,
    earnedRuns,
    gamesFinished,
    gamesPitched,
    gamesPlayed,
    gamesStarted,
    groundOuts,
    hitBatsmen,
    hits,
    holds,
    homeRuns,
    inheritedRunners,
    inheritedRunnersScored,
    intentionalWalks,
    losses,
    numberOfPitches,
    outs,
    pickoffs,
    pitchesThrown,
    rbi,
    runs,
    sacBunts,
    sacFlies,
    saveOpportunities,
    saves,
    shutouts,
    stolenBases,
    strikeOuts,
    strikes,
    triples,
    wildPitches,
    wins,
    singles,
    plateAppearances,
    unintentionalWalks
  )
SELECT DISTINCT
  gamePk,
  teamId,
  teamType,
  playerId,
  COALESCE(CAST(airOuts AS UNSIGNED), 0) airOuts,
  COALESCE(CAST(atBats AS UNSIGNED), 0) atBats,
  COALESCE(CAST(balls AS UNSIGNED), 0) balls,
  COALESCE(CAST(baseOnBalls AS UNSIGNED), 0) walks,
  COALESCE(CAST(battersFaced AS UNSIGNED), 0) battersFaced,
  COALESCE(CAST(blownSaves AS UNSIGNED), 0) blownSaves,
  COALESCE(CAST(catchersInterference AS UNSIGNED), 0) catchersInterference,
  COALESCE(CAST(caughtStealing AS UNSIGNED), 0) caughtStealing,
  COALESCE(CAST(completeGames AS UNSIGNED), 0) completeGames,
  COALESCE(CAST(doubles AS UNSIGNED), 0) doubles,
  COALESCE(CAST(earnedRuns AS UNSIGNED), 0) earnedRuns,
  COALESCE(CAST(gamesFinished AS UNSIGNED), 0) gamesFinished,
  COALESCE(CAST(gamesPitched AS UNSIGNED), 0) gamesPitched,
  COALESCE(CAST(gamesPlayed AS UNSIGNED), 0) gamesPlayed,
  COALESCE(CAST(gamesStarted AS UNSIGNED), 0) gamesStarted,
  COALESCE(CAST(groundOuts AS UNSIGNED), 0) groundOuts,
  COALESCE(CAST(hitBatsmen AS UNSIGNED), 0) hitBatsmen,
  COALESCE(CAST(hits AS UNSIGNED), 0) hits,
  COALESCE(CAST(holds AS UNSIGNED), 0) holds,
  COALESCE(CAST(homeRuns AS UNSIGNED), 0) homeRuns,
  COALESCE(CAST(inheritedRunners AS UNSIGNED), 0) inheritedRunners,
  COALESCE(CAST(inheritedRunnersScored AS UNSIGNED), 0) inheritedRunnersScored,
  COALESCE(CAST(intentionalWalks AS UNSIGNED), 0) intentionalWalks,
  COALESCE(CAST(losses AS UNSIGNED), 0) losses,
  COALESCE(CAST(numberOfPitches AS UNSIGNED), 0) numberOfPitches,
  COALESCE(CAST(outs AS UNSIGNED), 0) outs,
  COALESCE(CAST(pickoffs AS UNSIGNED), 0) pickoffs,
  COALESCE(CAST(pitchesThrown AS UNSIGNED), 0) pitchesThrown,
  COALESCE(CAST(rbi AS UNSIGNED), 0) rbi,
  COALESCE(CAST(runs AS UNSIGNED), 0) runs,
  COALESCE(CAST(sacBunts AS UNSIGNED), 0) sacBunts,
  COALESCE(CAST(sacFlies AS UNSIGNED), 0) sacFlies,
  COALESCE(CAST(saveOpportunities AS UNSIGNED), 0) saveOpportunities,
  COALESCE(CAST(saves AS UNSIGNED), 0) saves,
  COALESCE(CAST(shutouts AS UNSIGNED), 0) shutouts,
  COALESCE(CAST(stolenBases AS UNSIGNED), 0) stolenBases,
  COALESCE(CAST(strikeOuts AS UNSIGNED), 0) strikeOuts,
  COALESCE(CAST(strikes AS UNSIGNED), 0) strikes,
  COALESCE(CAST(triples AS UNSIGNED), 0) triples,
  COALESCE(CAST(wildPitches AS UNSIGNED), 0) wildPitches,
  COALESCE(CAST(wins AS UNSIGNED), 0) wins,
  COALESCE(CAST(hits AS UNSIGNED), 0) - COALESCE(CAST(homeRuns AS UNSIGNED), 0) - COALESCE(
    CAST(doubles AS UNSIGNED),
    0
  ) - COALESCE(CAST(triples AS UNSIGNED), 0) singles,
  COALESCE(CAST(atBats AS UNSIGNED), 0) + COALESCE(CAST(sacBunts AS UNSIGNED), 0) + COALESCE(
    CAST(sacFlies AS UNSIGNED),
    0
  ) + COALESCE(CAST(baseOnBalls AS UNSIGNED), 0) + COALESCE(CAST(hitBatsmen AS UNSIGNED), 0) plateAppearances,
  COALESCE(CAST(baseOnBalls AS UNSIGNED), 0) - COALESCE(
    CAST(intentionalWalks AS UNSIGNED),
    0
  ) unintentionalWalks
FROM stg_box_player_pitching
WHERE
  1 = 1
  AND (
    airOuts > 0
    OR atBats > 0
    OR balls > 0
    OR baseOnBalls > 0
    OR battersFaced > 0
    OR blownSaves > 0
    OR catchersInterference > 0
    OR caughtStealing > 0
    OR completeGames > 0
    OR doubles > 0
    OR earnedRuns > 0
    OR gamesFinished > 0
    OR gamesPitched > 0
    OR gamesPlayed > 0
    OR gamesStarted > 0
    OR groundOuts > 0
    OR hitBatsmen > 0
    OR hits > 0
    OR holds > 0
    OR homeRuns > 0
    OR inheritedRunners > 0
    OR inheritedRunnersScored > 0
    OR intentionalWalks > 0
    OR losses > 0
    OR numberOfPitches > 0
    OR outs > 0
    OR pickoffs > 0
    OR pitchesThrown > 0
    OR rbi > 0
    OR runs > 0
    OR sacBunts > 0
    OR sacFlies > 0
    OR saveOpportunities > 0
    OR saves > 0
    OR shutouts > 0
    OR stolenBases > 0
    OR strikeOuts > 0
    OR strikes > 0
    OR triples > 0
    OR wildPitches > 0
    OR wins > 0
  )
  AND (gamePk, teamId, playerId) NOT IN (
    SELECT
      gamePk,
      teamId,
      playerId
    FROM game_player_pitching_stats
  );

COMMIT;

END //

DELIMITER ;
