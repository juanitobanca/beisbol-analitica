USE baseball;

DROP PROCEDURE rem_run_expectancy_matrix;

DELIMITER //

CREATE PROCEDURE rem_run_expectancy_matrix()
BEGIN

INSERT INTO rem_run_expectancy_matrix(
    groupingId,
    groupingDescription,
    majorLeagueId,
    seasonId,
    venueId,
    runnersBeforePlay,
    sortingOrder,
    zeroOutsRunsScoredEndInning,
    zeroOutsRunsScoredBeforePlay,
    zeroOutsEvents,
    oneOutsRunsScoredEndInning,
    oneOutsRunsScoredBeforePlay,
    oneOutsEvents,
    twoOutsRunsScoredEndInning,
    twoOutsRunsScoredBeforePlay,
    twoOutsEvents
  )
  WITH pbp AS (
    /* Datos Play by Play */
    SELECT
      majorLeagueId,
      seasonId,
      venueId,
      outsBeforePlay,
      runnersBeforePlay,
      runsScoredEndInning,
      runsScoredBeforePlay
    FROM rem_play_by_play
    WHERE
      gameType2 = 'RS'
      AND (
        scheduledInnings > inning
        OR (
          scheduledInnings = inning
          AND halfInning = 'top'
        )
      )
  ),
  data AS (
    /* Convertir en columnas */
    SELECT
      majorLeagueId,
      seasonId,
      venueId,
      runnersBeforePlay,
      IF(outsBeforePlay = 0, runsScoredEndInning, 0) zeroOutsRunsScoredEndInning,
      IF(outsBeforePlay = 0, runsScoredBeforePlay, 0) zeroOutsRunsScoredBeforePlay,
      IF(outsBeforePlay = 0, 1, 0) zeroOutsEvents,
      IF(outsBeforePlay = 1, runsScoredEndInning, 0) oneOutsRunsScoredEndInning,
      IF(outsBeforePlay = 1, runsScoredBeforePlay, 0) oneOutsRunsScoredBeforePlay,
      IF(outsBeforePlay = 1, 1, 0) oneOutsEvents,
      IF(outsBeforePlay = 2, runsScoredEndInning, 0) twoOutsRunsScoredEndInning,
      IF(outsBeforePlay = 2, runsScoredBeforePlay, 0) twoOutsRunsScoredBeforePlay,
      IF(outsBeforePlay = 2, 1, 0) twoOutsEvents,
      CASE
        WHEN runnersBeforePlay = "---" THEN 0
        WHEN runnersBeforePlay = "1--" THEN 1
        WHEN runnersBeforePlay = "-2-" THEN 2
        WHEN runnersBeforePlay = "12-" THEN 3
        WHEN runnersBeforePlay = "--3" THEN 4
        WHEN runnersBeforePlay = "1-3" THEN 5
        WHEN runnersBeforePlay = "-23" THEN 6
        WHEN runnersBeforePlay = "123" THEN 7
      END sortingOrder
    FROM pbp
  )
SELECT
  /* Sumar todo */
  agg_grouping_id('majorLeagueId,seasonId') groupingId,
  agg_grouping_description('majorLeagueId,seasonId') groupingDescription,
  majorLeagueId,
  seasonId,
  NULL venueId,
  runnersBeforePlay,
  sortingOrder,
  SUM(zeroOutsRunsScoredEndInning) zeroOutsRunsScoredEndInning,
  SUM(zeroOutsRunsScoredBeforePlay) zeroOutsRunsScoredBeforePlay,
  SUM(zeroOutsEvents) zeroOutsEvents,
  SUM(oneOutsRunsScoredEndInning) oneOutsRunsScoredEndInning,
  SUM(oneOutsRunsScoredBeforePlay) oneOutsRunsScoredBeforePlay,
  SUM(oneOutsEvents) oneOutsEvents,
  SUM(twoOutsRunsScoredEndInning) twoOutsRunsScoredEndInning,
  SUM(twoOutsRunsScoredBeforePlay) twoOutsRunsScoredBeforePlay,
  SUM(twoOutsEvents) twoOutsEvents
FROM data
GROUP BY
  1, 2, 3, 4, 5, 6, 7

UNION ALL

SELECT
  agg_grouping_id('majorLeagueId,seasonId,venueId') groupingId,
  agg_grouping_description('majorLeagueId,seasonId,venueId') groupingDescription,
  majorLeagueId,
  seasonId,
  venueId,
  runnersBeforePlay,
  sortingOrder,
  SUM(zeroOutsRunsScoredEndInning) zeroOutsRunsScoredEndInning,
  SUM(zeroOutsRunsScoredBeforePlay) zeroOutsRunsScoredBeforePlay,
  SUM(zeroOutsEvents) zeroOutsEvents,
  SUM(oneOutsRunsScoredEndInning) oneOutsRunsScoredEndInning,
  SUM(oneOutsRunsScoredBeforePlay) oneOutsRunsScoredBeforePlay,
  SUM(oneOutsEvents) oneOutsEvents,
  SUM(twoOutsRunsScoredEndInning) twoOutsRunsScoredEndInning,
  SUM(twoOutsRunsScoredBeforePlay) twoOutsRunsScoredBeforePlay,
  SUM(twoOutsEvents) twoOutsEvents
FROM data
GROUP BY
  1, 2, 3, 4, 5, 6, 7;


UPDATE
  rem_run_expectancy_matrix
  SET zeroOutsRunExpectancy = IF( zeroOutsEvents > 0, ( zeroOutsRunsScoredEndInning - zeroOutsRunsScoredBeforePlay) / zeroOutsEvents, NULL )
  ,   oneOutsRunExpectancy =  IF( oneOutsEvents > 1,( oneOutsRunsScoredEndInning - oneOutsRunsScoredBeforePlay) / oneOutsEvents, NULL )
  ,   twoOutsRunExpectancy =  IF( twoOutsEvents > 2, ( twoOutsRunsScoredEndInning - twoOutsRunsScoredBeforePlay) / twoOutsEvents, NULL );


COMMIT;

END //

DELIMITER ;
