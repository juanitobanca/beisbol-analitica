USE baseball;

DROP PROCEDURE rem_play_by_play;

DELIMITER //

CREATE PROCEDURE rem_play_by_play()
BEGIN

INSERT INTO rem_play_by_play(
    majorLeagueId,
    seasonId,
    venueId,
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    playIndex,
    event,
    runnersBeforePlay,
    menOnBaseBeforePlay,
    runsScoredBeforePlay,
    outsBeforePlay,
    runsScoredInPlay,
    outsInPlay,
    runsScoredAfterPlay,
    outsAfterPlay,
    runsScoredEndInning
  )
WITH /* Obtener corredores por partido */
game_runners AS (
  SELECT
    g.majorLeagueId,
    g.seasonId,
    g.venueId,
    g.gamePk,
    r.inning,
    r.halfInning,
    r.atBatIndex,
    r.playIndex,
    r.runnerId,
    r.event,
    r.isOut,
    r.endBase,
    r.outNumber,
    CASE
      WHEN r.isOut OR endBase = 'score' THEN 4
      ELSE CAST(REPLACE(endBase, 'B', '') AS UNSIGNED)
    END runnerBase,
    IF(endBase = 'score', 1, 0) runScored
  FROM games g
  INNER JOIN runners r
    ON g.gamePk = r.gamePk
  WHERE g.gamePk NOT IN (
      SELECT
        gamePk
      FROM rem_play_by_play
    )
),
/* Obtener movimiento de jugadores a lo largo del inning y hasta cierto punto( atBatIndex,playIndex) */
runner_movements AS (
  SELECT
    n.majorLeagueId,
    n.seasonId,
    n.venueId,
    n.gamePk,
    n.inning,
    n.halfInning,
    n.atBatIndex,
    n.playIndex,
    n.event,
    b.runnerId,
    b.runnerBase,
    b.outNumber,
    b.endBase
  FROM game_runners n
  LEFT JOIN game_runners b
    ON n.gamePk = b.gamePk
    AND n.inning = b.inning
    AND n.halfInning = b.halfInning
    AND (
      n.atBatIndex > b.atBatIndex
      OR (
        n.atBatIndex = b.atBatIndex
        AND n.playIndex > b.playIndex
      )
    )
),
/* Obtener la base maxima de cada corredor hasta cierto punto(atBatIndex,playIndex). Si es 4, entonces el corredor
anoto o lo pusieron out */
runner_max_movement AS (
  SELECT
    majorLeagueId,
    seasonId,
    venueId,
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    playIndex,
    event,
    runnerId,
    MAX(runnerBase) runnerBase
  FROM runner_movements
  GROUP BY
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10
),
/* Obtener corredores al inicio de jugada en formato ---. */
runners_at_beginning_of_play AS (
  SELECT
    majorLeagueId,
    seasonId,
    venueId,
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    playIndex,
    event,
    CONCAT(
      IF(SUM(IF(runnerBase = 1, 1, 0)) = '1', '1', '-'),
      IF(SUM(IF(runnerBase = 2, 1, 0)) = '1', '2', '-'),
      IF(SUM(IF(runnerBase = 3, 1, 0)) = '1', '3', '-')
    ) runnersBeforePlay
  FROM runner_max_movement
  GROUP BY
    1, 2, 3, 4, 5, 6, 7, 8, 9
),
/* Obtener outs antes de la jugada*/
outs_at_beginning_of_play AS (
  SELECT
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    playIndex,
    event,
    MAX(outNumber) outsBeforePlay
  FROM runner_movements
  GROUP BY
    1, 2, 3, 4, 5, 6
),
/* Obtener corredores antes de la jugada */
runs_at_beginning_of_play AS (
  SELECT
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    playIndex,
    event,
    COUNT(DISTINCT runnerId) runsScoredBeforePlay
  FROM runner_movements
  WHERE endBase = 'score'
  GROUP BY
    1, 2, 3, 4, 5, 6
),
/* Obtener outs y carreras durante la jugada */
outs_and_runs_in_play AS (
  SELECT
    gamePk,
    inning,
    halfInning,
    atBatIndex,
    playIndex,
    event,
    SUM(isOut) outsInPlay,
    SUM(runScored) runsScoredInPlay
  FROM game_runners
  GROUP BY
    1, 2, 3, 4, 5, 6
),
/* Obtener outs y carreras al final del Inning */
outs_and_runs_end_inning AS (
  SELECT
    gamePk,
    inning,
    halfInning,
    SUM(runScored) runsScoredEndInning
  FROM game_runners
  GROUP BY
    1, 2, 3
) /* Juntar todo */
SELECT
  rb.majorLeagueId,
  rb.seasonId,
  rb.venueId,
  rb.gamePk,
  rb.inning,
  rb.halfInning,
  rb.atBatIndex,
  rb.playIndex,
  rb.event,
  rb.runnersBeforePlay,
  CASE WHEN rb.runnersBeforePlay = '---' THEN 'Empty'
       WHEN rb.runnersBeforePlay = '123' THEN 'Loaded'
       WHEN rb.runnersBeforePlay = '1--' THEN 'Men_On'
       WHEN rb.runnersBeforePlay IN ( '-23', '-2-', '--3', '1-3' , '12-') THEN 'RISP'
  END menOnBaseBeforePlay,
  COALESCE(rrb.runsScoredBeforePlay,0) runsScoredBeforePlay,
  COALESCE(ob.outsBeforePlay, 0) outsBeforePlay,
  COALESCE(ori.runsScoredInPlay, 0 ) runsScoredInPlay,
  COALESCE(ori.outsInPlay, 0 ) outsInPlay,
  COALESCE(ore.runsScoredEndInning, 0 ) - COALESCE(rrb.runsScoredBeforePlay, 0 ) runsScoredAfterPlay,
  COALESCE(ob.outsBeforePlay, 0 ) + COALESCE(ori.outsInPlay,0) outsAfterPlay,
  COALESCE(ore.runsScoredEndInning, 0 ) runsScoredEndInning
FROM runners_at_beginning_of_play rb
LEFT JOIN outs_at_beginning_of_play ob
  ON rb.gamePk = ob.gamePk
  AND rb.inning = ob.inning
  AND rb.halfInning = ob.halfInning
  AND rb.atBatIndex = ob.atBatIndex
  AND rb.playIndex = ob.playIndex
  AND rb.event = ob.event
LEFT JOIN runs_at_beginning_of_play rrb
  ON rb.gamePk = rrb.gamePk
  AND rb.inning = rrb.inning
  AND rb.halfInning = rrb.halfInning
  AND rb.atBatIndex = rrb.atBatIndex
  AND rb.playIndex = rrb.playIndex
  AND rb.event = rrb.event
LEFT JOIN outs_and_runs_in_play ori
  ON rb.gamePk = ori.gamePk
  AND rb.inning = ori.inning
  AND rb.halfInning = ori.halfInning
  AND rb.atBatIndex = ori.atBatIndex
  AND rb.playIndex = ori.playIndex
  AND rb.event = ori.event
INNER JOIN outs_and_runs_end_inning ore
  ON rb.gamePk = ore.gamePk
  AND rb.inning = ore.inning
  AND rb.halfInning = ore.halfInning;

/* Actualizar Runners After Play */
UPDATE
  rem_play_by_play pbp
INNER JOIN (
    WITH /* Obtener la siguiente jugada para todas las jugadas. Puede ser por medio de atBatIndex o  atBatIndex, playIndex. */
    rem_next_play AS (
      SELECT
        n.gamePk,
        n.inning,
        n.halfInning,
        n.atBatIndex,
        n.playIndex
        -- Mismo atbat
        , (
          SELECT
            MIN(a.playIndex)
          FROM rem_play_by_play a
          WHERE
            n.gamePk = a.gamePk
            AND n.atBatIndex = a.atBatIndex
            AND n.playIndex < a.playIndex
        ) playIndex2
        -- Siguiente atbat
        , n.atBatIndex + 1 atBatIndex2,
        (
          SELECT
            MIN(a.playIndex)
          FROM rem_play_by_play a
          WHERE
            n.gamePk = a.gamePk
            AND n.inning = a.inning
            AND n.halfInning = a.halfInning
            AND n.atBatIndex + 1 = a.atBatIndex
        ) playIndex3
      FROM rem_play_by_play n
      WHERE
        runnersAfterPlay IS NULL
    )
      /* Obtener corredores iniciales de la siguiente jugada. */
      SELECT
        rnp.gamePk,
        rnp.inning,
        rnp.halfInning,
        rnp.atBatIndex,
        rnp.playIndex,
        COALESCE(runnersBeforePlay, '---') runnersAfterPlay,
        CASE WHEN runnersBeforePlay = '---' OR runnersBeforePlay IS NULL THEN 'Empty'
             WHEN runnersBeforePlay = '123' THEN 'Loaded'
             WHEN runnersBeforePlay = '1--' THEN 'Men_On'
             WHEN runnersBeforePlay IN ( '-23', '-2-', '--3', '1-3' , '12-') THEN 'RISP'
        END menOnBaseAfterPlay
      FROM rem_next_play rnp
      LEFT JOIN rem_play_by_play pbp
        ON rnp.gamePk = pbp.gamePk
        AND rnp.inning = pbp.inning
        AND rnp.halfInning = pbp.halfInning
        /* Si no hay playIndex2, significa que la jugada se dio en el siguiente atbat.
           Si hay playIndex2, significa que la jugada se dio en el mismo atbat. */
        AND IF(rnp.playIndex2 IS NOT NULL, rnp.atBatIndex, rnp.atBatIndex2) = pbp.atBatIndex
        AND IF(rnp.playIndex2 IS NOT NULL, rnp.playIndex2, rnp.playIndex3) = pbp.playIndex
  ) rap
  ON pbp.gamePk = rap.gamePk
  AND pbp.inning = rap.inning
  AND pbp.halfInning = rap.halfInning
  AND pbp.atBatIndex = rap.atBatIndex
  AND pbp.playIndex = rap.playIndex
  SET pbp.runnersAfterPlay = rap.runnersAfterPlay
  ,   pbp.menOnBaseAfterPlay = rap.menOnBaseAfterPlay;

/* Actualizar battingTeamId, pitchingTeamId, batterId, pitcherId */
UPDATE rem_play_by_play pbp
INNER JOIN atbats ab
ON pbp.gamePk = ab.gamePk
AND pbp.atbatIndex = ab.atBatIndex
SET pbp.battingTeamId = ab.battingTeamId
,   pbp.pitchingTeamId = ab.pitchingTeamId
,   pbp.batterId = ab.batterId
,   pbp.pitcherId = ab.pitcherId
,   pbp.batSide =  ab.batSide
,   pbp.pitchHand = ab.pitchHand;

/* Actualizar scheduledInnings, battingTeamScoreEndGame,  pitchingTeamScoreEndGame */
UPDATE
  rem_play_by_play pbp
INNER JOIN games g
ON pbp.gamePk = g.gamePk
SET pbp.scheduledInnings = g.scheduledInnings
,   pbp.battingTeamScoreEndGame  = IF( pbp.battingTeamId = g.homeTeamId, g.homeScore, g.awayScore )
,   pbp.pitchingTeamScoreEndGame = IF( pbp.pitchingTeamId = g.homeTeamId, g.homeScore, g.awayScore )
,   pbp.gameType2                = g.gameType2;

/* Actualizar score en cada momento del juego( battingTeamScoreStartInning, pitchingTeamScoreStartInning )*/
UPDATE
  rem_play_by_play pbp
INNER JOIN (
    WITH runs_scored_per_inning AS (
      SELECT DISTINCT
        gamePk,
        inning,
        atBatIndex,
        playIndex,
        runsScoredInPlay,
        battingTeamId,
        pitchingTeamId
      FROM rem_play_by_play
    )
    SELECT
      n.gamePk,
      n.atBatIndex,
      n.playIndex,
      runsScoredInPlay,
      (
      SELECT
        SUM(runsScoredInPlay)
      FROM runs_scored_per_inning b
      WHERE
        n.gamePk = b.gamePk
        AND n.battingTeamId = b.battingTeamId
        AND (
          n.atBatIndex > b.atBatIndex
          OR (
            n.atBatIndex = b.atBatIndex
            AND n.playIndex > b.playIndex
          )
        )
    ) battingTeamScore,
      (
      SELECT
        SUM(runsScoredInPlay)
      FROM runs_scored_per_inning p
      WHERE
        n.gamePk = p.gamePk
        AND n.pitchingTeamId = p.battingTeamId
        AND n.atBatIndex > p.atBatIndex
    ) pitchingTeamScore
    FROM rem_play_by_play n
  ) rsi
  ON pbp.gamePk = rsi.gamePk
  AND pbp.atBatIndex = rsi.atBatIndex
  AND pbp.playIndex = rsi.playIndex
  SET pbp.battingTeamScore = Coalesce( rsi.battingTeamScore,0)
  ,   pbp.pitchingTeamScore = Coalesce( rsi.pitchingTeamScore,0);

/* Actualizar los strikes y bolas antes de la jugada */
UPDATE
  rem_play_by_play pbp
LEFT JOIN (
  SELECT
    pbp.gamePk,
    pbp.atBatIndex,
    pbp.playIndex,
    MAX(startStrikes) strikesBeforePlay,
    MAX(startBalls) ballsBeforePlay
  FROM rem_play_by_play pbp
  INNER JOIN pitches p
    ON pbp.gamePk = p.gamePk
    AND pbp.atBatIndex = p.atBatIndex
    AND pbp.playIndex >= pbp.playIndex
  GROUP BY
    1, 2, 3
) bs
  ON pbp.gamePk = bs.gamePk
  AND pbp.atBatIndex = bs.atBatIndex
  AND pbp.playIndex = bs.playIndex
  SET pbp.strikesBeforePlay = Coalesce(bs.strikesBeforePlay,0)
  ,   pbp.ballsBeforePlay = Coalesce(bs.ballsBeforePlay,0);

/* Actualizar corredor a cargo de la jugada y pitcher responsable de corredor. */
UPDATE
  rem_play_by_play pbp
INNER JOIN (
  SELECT
    gamePk,
    atBatIndex,
    playIndex,
    runnerId,
    event,
    responsiblePitcherId
  FROM runners
  WHERE
    eventType IN
    (
      'caught_stealing_2b',
      'caught_stealing_3b',
      'caught_stealing_home',
      'pickoff_1b',
      'pickoff_2b',
      'pickoff_3b',
      'pickoff_caught_stealing_2b',
      'pickoff_caught_stealing_3b',
      'pickoff_caught_stealing_home',
      'stolen_base_2b',
      'stolen_base_3b',
      'stolen_base_home'
    )
  ) r
ON pbp.gamePk = r.gamePk
AND pbp.atBatIndex = r.atBatIndex
AND pbp.playIndex = r.playIndex
AND pbp.event = r.event
SET pbp.runnerId = r.runnerId
,   pbp.responsiblePitcherId = r.responsiblePitcherId;

/*  Es aparicion al plato? */
UPDATE rem_play_by_play
SET isPlateAppearance = event NOT IN (
  'Balk',
  'Caught Stealing 2B',
  'Caught Stealing 3B',
  'Caught Stealing Home',
  'Other Advance',
  'Passed Ball',
  'Pickoff 1B',
  'Pickoff 2B',
  'Pickoff 3B',
  'Pickoff Caught Stealing 2B',
  'Pickoff Caught Stealing 3B',
  'Pickoff Caught Stealing Home',
  'Pickoff Error 1B',
  'Pickoff Error 2B',
  'Pickoff Error 3B',
  'Runner Double Play',
  'Runner Interference',
  'Runner Out',
  'Stolen Base 2B',
  'Stolen Base 3B',
  'Stolen Base Home',
  'Wild Pitch'
);

COMMIT;

END //

DELIMITER ;
