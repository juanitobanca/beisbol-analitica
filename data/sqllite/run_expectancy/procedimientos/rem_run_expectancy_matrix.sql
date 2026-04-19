-- Procedure: rem_run_expectancy_matrix
-- NOTE: This procedure references MySQL UDFs agg_grouping_id() and agg_grouping_description()
-- which must be handled at the application layer. Replace those calls with hardcoded values
-- or application-computed values before executing.

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
      CASE WHEN outsBeforePlay = 0 THEN runsScoredEndInning ELSE 0 END AS zeroOutsRunsScoredEndInning,
      CASE WHEN outsBeforePlay = 0 THEN runsScoredBeforePlay ELSE 0 END AS zeroOutsRunsScoredBeforePlay,
      CASE WHEN outsBeforePlay = 0 THEN 1 ELSE 0 END AS zeroOutsEvents,
      CASE WHEN outsBeforePlay = 1 THEN runsScoredEndInning ELSE 0 END AS oneOutsRunsScoredEndInning,
      CASE WHEN outsBeforePlay = 1 THEN runsScoredBeforePlay ELSE 0 END AS oneOutsRunsScoredBeforePlay,
      CASE WHEN outsBeforePlay = 1 THEN 1 ELSE 0 END AS oneOutsEvents,
      CASE WHEN outsBeforePlay = 2 THEN runsScoredEndInning ELSE 0 END AS twoOutsRunsScoredEndInning,
      CASE WHEN outsBeforePlay = 2 THEN runsScoredBeforePlay ELSE 0 END AS twoOutsRunsScoredBeforePlay,
      CASE WHEN outsBeforePlay = 2 THEN 1 ELSE 0 END AS twoOutsEvents,
      CASE
        WHEN runnersBeforePlay = '---' THEN 0
        WHEN runnersBeforePlay = '1--' THEN 1
        WHEN runnersBeforePlay = '-2-' THEN 2
        WHEN runnersBeforePlay = '12-' THEN 3
        WHEN runnersBeforePlay = '--3' THEN 4
        WHEN runnersBeforePlay = '1-3' THEN 5
        WHEN runnersBeforePlay = '-23' THEN 6
        WHEN runnersBeforePlay = '123' THEN 7
      END sortingOrder
    FROM pbp
  )
SELECT
  /* Sumar todo */
  -- agg_grouping_id('majorLeagueId,seasonId') -- must be computed in application layer
  NULL AS groupingId,
  -- agg_grouping_description('majorLeagueId,seasonId') -- must be computed in application layer
  'MAJORLEAGUEID_SEASONID' AS groupingDescription,
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
  -- agg_grouping_id('majorLeagueId,seasonId,venueId') -- must be computed in application layer
  NULL AS groupingId,
  -- agg_grouping_description('majorLeagueId,seasonId,venueId') -- must be computed in application layer
  'MAJORLEAGUEID_SEASONID_VENUEID' AS groupingDescription,
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


UPDATE rem_run_expectancy_matrix
SET zeroOutsRunExpectancy = CASE WHEN zeroOutsEvents > 0 THEN ( zeroOutsRunsScoredEndInning - zeroOutsRunsScoredBeforePlay) / zeroOutsEvents ELSE NULL END,
    oneOutsRunExpectancy = CASE WHEN oneOutsEvents > 1 THEN ( oneOutsRunsScoredEndInning - oneOutsRunsScoredBeforePlay) / oneOutsEvents ELSE NULL END,
    twoOutsRunExpectancy = CASE WHEN twoOutsEvents > 2 THEN ( twoOutsRunsScoredEndInning - twoOutsRunsScoredBeforePlay) / twoOutsEvents ELSE NULL END;
