-- Procedure: game_player_batting_stats
INSERT INTO game_player_batting_stats(
    gamePk,
    teamId,
    teamType,
    playerId,
    atBats,
    walks,
    catchersInterference,
    caughtStealing,
    doubles,
    flyOuts,
    groundIntoDoublePlay,
    groundIntoTriplePlay,
    groundOuts,
    hitByPitch,
    hits,
    homeRuns,
    intentionalWalks,
    leftOnBase,
    pickoffs,
    rbi,
    runs,
    sacBunts,
    sacFlies,
    stolenBases,
    strikeOuts,
    totalBases,
    triples,
    singles,
    plateAppearances,
    unintentionalWalks
  )
SELECT DISTINCT
  gamePk,
  teamId,
  teamType,
  playerId,
  COALESCE(CAST(atBats AS INTEGER), 0) atBats,
  COALESCE(CAST(baseOnBalls AS INTEGER), 0) walks,
  COALESCE(CAST(catchersInterference AS INTEGER), 0) catchersInterference,
  COALESCE(CAST(caughtStealing AS INTEGER), 0) caughtStealing,
  COALESCE(CAST(doubles AS INTEGER), 0) doubles,
  COALESCE(CAST(flyOuts AS INTEGER), 0) flyOuts,
  COALESCE(CAST(groundIntoDoublePlay AS INTEGER), 0) groundIntoDoublePlay,
  COALESCE(CAST(groundIntoTriplePlay AS INTEGER), 0) groundIntoTriplePlay,
  COALESCE(CAST(groundOuts AS INTEGER), 0) groundOuts,
  COALESCE(CAST(hitByPitch AS INTEGER), 0) hitByPitch,
  COALESCE(CAST(hits AS INTEGER), 0) hits,
  COALESCE(CAST(homeRuns AS INTEGER), 0) homeRuns,
  COALESCE(CAST(intentionalWalks AS INTEGER), 0) intentionalWalks,
  COALESCE(CAST(leftOnBase AS INTEGER), 0) leftOnBase,
  COALESCE(CAST(pickoffs AS INTEGER), 0) pickoffs,
  COALESCE(CAST(rbi AS INTEGER), 0) rbi,
  COALESCE(CAST(runs AS INTEGER), 0) runs,
  COALESCE(CAST(sacBunts AS INTEGER), 0) sacBunts,
  COALESCE(CAST(sacFlies AS INTEGER), 0) sacFlies,
  COALESCE(CAST(stolenBases AS INTEGER), 0) stolenBases,
  COALESCE(CAST(strikeOuts AS INTEGER), 0) strikeOuts,
  COALESCE(CAST(totalBases AS INTEGER), 0) totalBases,
  COALESCE(CAST(triples AS INTEGER), 0) triples,
  COALESCE(CAST(hits AS INTEGER), 0) - COALESCE(CAST(homeRuns AS INTEGER), 0) - COALESCE(
    CAST(doubles AS INTEGER),
    0
  ) - COALESCE(CAST(triples AS INTEGER), 0) singles,
  COALESCE(CAST(atBats AS INTEGER), 0) + COALESCE(CAST(sacBunts AS INTEGER), 0) + COALESCE(
    CAST(sacFlies AS INTEGER),
    0
  ) + COALESCE(CAST(baseOnBalls AS INTEGER), 0) + COALESCE(CAST(hitByPitch AS INTEGER), 0) plateAppearances,
  COALESCE(CAST(baseOnBalls AS INTEGER), 0) - COALESCE(
    CAST(intentionalWalks AS INTEGER),
    0
  ) unintentionalWalks
FROM stg_box_player_batting
WHERE
  1 = 1
  AND (
    atBats > 0
    OR baseOnBalls > 0
    OR catchersInterference > 0
    OR caughtStealing > 0
    OR doubles > 0
    OR flyOuts > 0
    OR groundIntoDoublePlay > 0
    OR groundIntoTriplePlay > 0
    OR groundOuts > 0
    OR hitByPitch > 0
    OR hits > 0
    OR homeRuns > 0
    OR intentionalWalks > 0
    OR leftOnBase > 0
    OR pickoffs > 0
    OR rbi > 0
    OR runs > 0
    OR sacBunts > 0
    OR sacFlies > 0
    OR stolenBases > 0
    OR strikeOuts > 0
    OR totalBases > 0
    OR triples > 0
  )
  AND (gamePk, teamId, playerId) NOT IN (
    SELECT
      gamePk,
      teamId,
      playerId
    FROM game_player_batting_stats
  );
