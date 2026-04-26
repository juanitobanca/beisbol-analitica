-- Procedure: rem_play_by_play

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
      ELSE CAST(REPLACE(endBase, 'B', '') AS INTEGER)
    END runnerBase,
    CASE WHEN endBase = 'score' THEN 1 ELSE 0 END AS runScored
  FROM games g
  INNER JOIN runners r
    ON g.gamePk = r.gamePk
  WHERE NOT EXISTS (
    SELECT 1
    FROM rem_play_by_play pbp
    WHERE pbp.gamePk = g.gamePk
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
    MAX(runnerBase) OVER (
        PARTITION BY gamePk, inning, halfInning, runnerId
        ORDER BY atBatIndex, playIndex
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
      ) AS runnerBase
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
    CASE WHEN SUM(CASE WHEN runnerBase = 1 THEN 1 ELSE 0 END) = 1 THEN '1' ELSE '-' END
    || CASE WHEN SUM(CASE WHEN runnerBase = 2 THEN 1 ELSE 0 END) = 1 THEN '2' ELSE '-' END
    || CASE WHEN SUM(CASE WHEN runnerBase = 3 THEN 1 ELSE 0 END) = 1 THEN '3' ELSE '-' END
    AS runnersBeforePlay
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

/* Actualizar Runners After Play
Este query actualiza la columna runnersAfterPlay (corredores después de la jugada) en una tabla de béisbol play-by-play.
La lógica es: "los corredores después de esta jugada son los mismos que había antes de la siguiente jugada

Cada turno al bate (atBatIndex) puede tener múltiples jugadas (playIndex). Entonces hay dos casos:

Caso 1 — Hay otra jugada dentro del mismo turno al bate
Si existe un playIndex mayor dentro del mismo atBatIndex, entonces:
  * Se queda en el mismo atBatIndex
  * El siguiente playIndex es ese mínimo mayor

Caso 2 — Es la última jugada del turno al bate
Si no hay más jugadas en este turno, salta al siguiente turno:
  * atBatIndex + 1
  * El playIndex mínimo de ese nuevo turno
*/

UPDATE rem_play_by_play
SET runnersAfterPlay = (
  SELECT COALESCE(next_play.next_runners, '---')
  FROM (
    SELECT
      gamePk,
      inning,
      halfInning,
      atBatIndex,
      playIndex,
      LEAD(runnersBeforePlay) OVER (
        PARTITION BY gamePk, inning, halfInning
        ORDER BY atBatIndex, playIndex
      ) AS next_runners
    FROM rem_play_by_play
  ) next_play
  WHERE next_play.gamePk      = rem_play_by_play.gamePk
    AND next_play.inning      = rem_play_by_play.inning
    AND next_play.halfInning  = rem_play_by_play.halfInning
    AND next_play.atBatIndex  = rem_play_by_play.atBatIndex
    AND next_play.playIndex   = rem_play_by_play.playIndex
)
WHERE runnersAfterPlay IS NULL;


UPDATE rem_play_by_play
SET menOnBaseAfterPlay = CASE
  WHEN runnersAfterPlay = '---' OR runnersAfterPlay IS NULL THEN 'Empty'
  WHEN runnersAfterPlay = '123' THEN 'Loaded'
  WHEN runnersAfterPlay = '1--' THEN 'Men_On'
  WHEN runnersAfterPlay IN ( '-23', '-2-', '--3', '1-3' , '12-') THEN 'RISP'
END
WHERE runnersAfterPlay IS NOT NULL;

/* Actualizar battingTeamId, pitchingTeamId, batterId, pitcherId */
UPDATE rem_play_by_play
SET battingTeamId = (SELECT ab.battingTeamId FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex),
    pitchingTeamId = (SELECT ab.pitchingTeamId FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex),
    batterId = (SELECT ab.batterId FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex),
    pitcherId = (SELECT ab.pitcherId FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex),
    batSide = (SELECT ab.batSide FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex),
    pitchHand = (SELECT ab.pitchHand FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex)
WHERE EXISTS (SELECT 1 FROM atbats ab WHERE rem_play_by_play.gamePk = ab.gamePk AND rem_play_by_play.atBatIndex = ab.atBatIndex);

/* Actualizar scheduledInnings, battingTeamScoreEndGame,  pitchingTeamScoreEndGame */
UPDATE rem_play_by_play
SET scheduledInnings = (SELECT g.scheduledInnings FROM games g WHERE rem_play_by_play.gamePk = g.gamePk),
    battingTeamScoreEndGame = (SELECT CASE WHEN rem_play_by_play.battingTeamId = g.homeTeamId THEN g.homeScore ELSE g.awayScore END FROM games g WHERE rem_play_by_play.gamePk = g.gamePk),
    pitchingTeamScoreEndGame = (SELECT CASE WHEN rem_play_by_play.pitchingTeamId = g.homeTeamId THEN g.homeScore ELSE g.awayScore END FROM games g WHERE rem_play_by_play.gamePk = g.gamePk),
    gameType2 = (SELECT g.gameType2 FROM games g WHERE rem_play_by_play.gamePk = g.gamePk)
WHERE EXISTS (SELECT 1 FROM games g WHERE rem_play_by_play.gamePk = g.gamePk);

/* Actualizar score en cada momento del juego( battingTeamScoreStartInning, pitchingTeamScoreStartInning )*/
UPDATE rem_play_by_play
SET battingTeamScore = COALESCE((
      SELECT SUM(b.runsScoredInPlay)
      FROM rem_play_by_play b
      WHERE rem_play_by_play.gamePk = b.gamePk
        AND rem_play_by_play.battingTeamId = b.battingTeamId
        AND (
          rem_play_by_play.atBatIndex > b.atBatIndex
          OR (
            rem_play_by_play.atBatIndex = b.atBatIndex
            AND rem_play_by_play.playIndex > b.playIndex
          )
        )
    ), 0),
    pitchingTeamScore = COALESCE((
      SELECT SUM(p.runsScoredInPlay)
      FROM rem_play_by_play p
      WHERE rem_play_by_play.gamePk = p.gamePk
        AND rem_play_by_play.pitchingTeamId = p.battingTeamId
        AND rem_play_by_play.atBatIndex > p.atBatIndex
    ), 0);

/* Actualizar los strikes y bolas antes de la jugada */
UPDATE rem_play_by_play
SET strikesBeforePlay = COALESCE((
      SELECT MAX(p.startStrikes)
      FROM pitches p
      WHERE rem_play_by_play.gamePk = p.gamePk
        AND rem_play_by_play.atBatIndex = p.atBatIndex
        AND rem_play_by_play.playIndex >= p.playIndex
    ), 0),
    ballsBeforePlay = COALESCE((
      SELECT MAX(p.startBalls)
      FROM pitches p
      WHERE rem_play_by_play.gamePk = p.gamePk
        AND rem_play_by_play.atBatIndex = p.atBatIndex
        AND rem_play_by_play.playIndex >= p.playIndex
    ), 0);

/* Actualizar corredor a cargo de la jugada y pitcher responsable de corredor. */
UPDATE rem_play_by_play
SET runnerId = (
      SELECT r.runnerId FROM runners r
      WHERE rem_play_by_play.gamePk = r.gamePk
        AND rem_play_by_play.atBatIndex = r.atBatIndex
        AND rem_play_by_play.playIndex = r.playIndex
        AND rem_play_by_play.event = r.event
        AND r.eventType IN (
          'caught_stealing_2b','caught_stealing_3b','caught_stealing_home',
          'pickoff_1b','pickoff_2b','pickoff_3b',
          'pickoff_caught_stealing_2b','pickoff_caught_stealing_3b','pickoff_caught_stealing_home',
          'stolen_base_2b','stolen_base_3b','stolen_base_home'
        )
      LIMIT 1
    ),
    responsiblePitcherId = (
      SELECT r.responsiblePitcherId FROM runners r
      WHERE rem_play_by_play.gamePk = r.gamePk
        AND rem_play_by_play.atBatIndex = r.atBatIndex
        AND rem_play_by_play.playIndex = r.playIndex
        AND rem_play_by_play.event = r.event
        AND r.eventType IN (
          'caught_stealing_2b','caught_stealing_3b','caught_stealing_home',
          'pickoff_1b','pickoff_2b','pickoff_3b',
          'pickoff_caught_stealing_2b','pickoff_caught_stealing_3b','pickoff_caught_stealing_home',
          'stolen_base_2b','stolen_base_3b','stolen_base_home'
        )
      LIMIT 1
    )
WHERE EXISTS (
  SELECT 1 FROM runners r
  WHERE rem_play_by_play.gamePk = r.gamePk
    AND rem_play_by_play.atBatIndex = r.atBatIndex
    AND rem_play_by_play.playIndex = r.playIndex
    AND rem_play_by_play.event = r.event
    AND r.eventType IN (
      'caught_stealing_2b','caught_stealing_3b','caught_stealing_home',
      'pickoff_1b','pickoff_2b','pickoff_3b',
      'pickoff_caught_stealing_2b','pickoff_caught_stealing_3b','pickoff_caught_stealing_home',
      'stolen_base_2b','stolen_base_3b','stolen_base_home'
    )
);

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
