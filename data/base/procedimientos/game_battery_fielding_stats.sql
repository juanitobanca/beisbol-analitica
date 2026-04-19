-- Procedure: game_battery_fielding_stats
INSERT INTO game_battery_fielding_stats(
    gamePk,
    teamId,
    pitcherId,
    catcherId,
    caughtStealingSecondBase,
    caughtStealingThirdBase,
    caughtStealingHome,
    caughtStealing,
    passedBalls,
    pickoffFirstBase,
    pickoffSecondBase,
    pickoffThirdBase,
    pickOffs,
    pickoffCaughtStealingFirstBase,
    pickoffCaughtStealingSecondBase,
    pickoffCaughtStealingThirdBase,
    pickoffCaughtStealing,
    pickoffErrorFirstBase,
    pickoffErrorSecondBase,
    pickoffErrorThirdBase,
    pickoffErrors,
    stolenSecondBase,
    stolenThirdBase,
    stolenHome,
    stolenBases,
    wildPitches
  )
  WITH gps AS (
    /* Obtener todos los jugadores que fueron P y C durante un partido */
    SELECT
      gamePk,
      teamId,
      positionAbbrev,
      playerId
    FROM game_player_positions
    WHERE
      positionAbbrev IN ('P', 'C')
  ),
  ds AS (
    /* Obtener todas las sustituciones de P y C */
    SELECT
      gamePk,
      atBatIndex + playIndex * .1 AS atBatPlayIndex,
      pitchingTeamId AS teamId,
      positionAbbrev,
      playerId
    FROM defensive_substitutions
    WHERE
      positionAbbrev IN ('P', 'C')
  ),
  ns AS (
    /* Obtener jugadores que no fueron sustituidos */
    SELECT
      gps.*
    FROM gps
    LEFT JOIN ds
      ON gps.gamePk = ds.gamePk
      AND gps.playerId = ds.playerId
    WHERE
      ds.playerId IS NULL
  ),
  sns AS (
    /* Unir jugadores sustituidos con no sustituidos*/
    SELECT
      gamePk,
      atBatPlayIndex,
      teamId,
      positionAbbrev,
      playerId
    FROM ds

    UNION ALL

    SELECT
      gamePk,
      1.0 AS atBatPlayIndex,
      teamId,
      positionAbbrev,
      playerId
    FROM ns
  ),
  act AS (
    /* Acciones */
    SELECT
      gamePk,
      pitchingTeamId AS teamId,
      atBatIndex + playIndex * .1 AS atBatPlayIndex,
      eventType
    FROM actions a
    WHERE
      eventType IN (
        'caught_stealing_2b',
        'caught_stealing_3b',
        'caught_stealing_home',
        'passed_ball',
        'pickoff_1b',
        'pickoff_2b',
        'pickoff_3b',
        'pickoff_caught_stealing_2b',
        'pickoff_caught_stealing_3b',
        'pickoff_caught_stealing_home',
        'pickoff_error_1b',
        'pickoff_error_2b',
        'pickoff_error_3b',
        'stolen_base_2b',
        'stolen_base_3b',
        'stolen_base_home',
        'wild_pitch'
      )
  ),
  pitcher_catcher_idx AS (
    /* Obtener AtBatPlayIndex mas reciente de que ocurriera la jugada en actions */
    SELECT
      act.gamePk,
      act.atBatPlayIndex,
      act.teamId,
      act.eventType,
      MAX(CASE WHEN sns.positionAbbrev = 'P' THEN sns.atBatPlayIndex ELSE 0 END) pitcherAtBatPlayIndex,
      MAX(CASE WHEN sns.positionAbbrev = 'C' THEN sns.atBatPlayIndex ELSE 0 END) catcherAtBatPlayIndex
    FROM act
    INNER JOIN sns
      ON act.gamePk = sns.gamePk
      AND act.teamId = sns.teamId
      AND act.atBatPlayIndex >= sns.atBatPlayIndex
    GROUP BY
      1, 2, 3, 4
  )
SELECT
  pci.gamePk,
  pci.teamId,
  p.playerId AS pitcherId,
  c.playerId AS catcherId,
  CASE WHEN eventType = 'caught_stealing_2b' THEN 1 ELSE 0 END caughtStealingSecondBase,
  CASE WHEN eventType = 'caught_stealing_3b' THEN 1 ELSE 0 END caughtStealingThirdBase,
  CASE WHEN eventType = 'caught_stealing_home' THEN 1 ELSE 0 END caughtStealingHome,
  CASE WHEN eventType IN ('caught_stealing_2b', 'caught_stealing_3b', 'caught_stealing_home') THEN 1 ELSE 0 END caughtStealing,
  CASE WHEN eventType = 'passed_ball' THEN 1 ELSE 0 END passedBalls,
  CASE WHEN eventType = 'pickoff_1b' THEN 1 ELSE 0 END pickoffFirstBase,
  CASE WHEN eventType = 'pickoff_2b' THEN 1 ELSE 0 END pickoffSecondBase,
  CASE WHEN eventType = 'pickoff_3b' THEN 1 ELSE 0 END pickoffThirdBase,
  CASE WHEN eventType IN ('pickoff_1b', 'pickoff_2b', 'pickoff_3b') THEN 1 ELSE 0 END pickOffs,
  CASE WHEN eventType = 'pickoff_caught_stealing_2b' THEN 1 ELSE 0 END pickoffCaughtStealingFirstBase,
  CASE WHEN eventType = 'pickoff_caught_stealing_3b' THEN 1 ELSE 0 END pickoffCaughtStealingSecondBase,
  CASE WHEN eventType = 'pickoff_caught_stealing_home' THEN 1 ELSE 0 END pickoffCaughtStealingThirdBase,
  CASE WHEN eventType IN ('pickoff_caught_stealing_2b', 'pickoff_caught_stealing_3b', 'pickoff_caught_stealing_home') THEN 1 ELSE 0 END pickoffCaughtStealing,
  CASE WHEN eventType = 'pickoff_error_1b' THEN 1 ELSE 0 END pickoffErrorFirstBase,
  CASE WHEN eventType = 'pickoff_error_2b' THEN 1 ELSE 0 END pickoffErrorSecondBase,
  CASE WHEN eventType = 'pickoff_error_3b' THEN 1 ELSE 0 END pickoffErrorThirdBase,
  CASE WHEN eventType IN ('pickoff_error_1b', 'pickoff_error_2b', 'pickoff_error_3b') THEN 1 ELSE 0 END pickoffErrors,
  CASE WHEN eventType = 'stolen_base_2b' THEN 1 ELSE 0 END stolenSecondBase,
  CASE WHEN eventType = 'stolen_base_3b' THEN 1 ELSE 0 END stolenThirdBase,
  CASE WHEN eventType = 'stolen_base_home' THEN 1 ELSE 0 END stolenHome,
  CASE WHEN eventType IN ('stolen_base_2b', 'stolen_base_3b', 'stolen_base_home') THEN 1 ELSE 0 END stolenBases,
  CASE WHEN eventType = 'wild_pitch' THEN 1 ELSE 0 END wildPitches
FROM pitcher_catcher_idx pci
INNER JOIN sns p
  ON pci.gamePk = p.gamePk
  AND pci.teamId = p.teamId
  AND pci.pitcherAtBatPlayIndex = p.atBatPlayIndex
  AND p.positionAbbrev = 'P'
INNER JOIN sns c
  ON pci.gamePk = c.gamePk
  AND pci.teamId = c.teamId
  AND pci.catcherAtBatPlayIndex = c.atBatPlayIndex
  AND c.positionAbbrev = 'C'
WHERE pci.gamePk NOT IN ( SELECT gamePk
                          FROM game_battery_fielding_stats
                        );
