USE baseball;

DROP PROCEDURE game_battery_fielding_stats;

DELIMITER //

CREATE PROCEDURE game_battery_fielding_stats()
BEGIN

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
      MAX(IF(sns.positionAbbrev = 'P', sns.atBatPlayIndex, 0)) pitcherAtBatPlayIndex,
      MAX(IF(sns.positionAbbrev = 'C', sns.atBatPlayIndex, 0)) catcherAtBatPlayIndex
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
  IF(eventType = 'caught_stealing_2b', 1, 0) caughtStealingSecondBase,
  IF(eventType = 'caught_stealing_3b', 1, 0) caughtStealingThirdBase,
  IF(eventType = 'caught_stealing_home', 1, 0) caughtStealingHome,
  IF(eventType IN ('caught_stealing_2b', 'caught_stealing_3b', 'caught_stealing_home'), 1, 0) caughtStealing,
  IF(eventType = 'passed_ball', 1, 0) passedBalls,
  IF(eventType = 'pickoff_1b', 1, 0) pickoffFirstBase,
  IF(eventType = 'pickoff_2b', 1, 0) pickoffSecondBase,
  IF(eventType = 'pickoff_3b', 1, 0) pickoffThirdBase,
  IF(eventType IN ('pickoff_1b', 'pickoff_2b', 'pickoff_3b'), 1, 0) pickOffs,
  IF(eventType = 'pickoff_caught_stealing_2b', 1, 0) pickoffCaughtStealingFirstBase,
  IF(eventType = 'pickoff_caught_stealing_3b', 1, 0) pickoffCaughtStealingSecondBase,
  IF(eventType = 'pickoff_caught_stealing_home', 1, 0) pickoffCaughtStealingThirdBase,
  IF(eventType IN ('pickoff_caught_stealing_2b', 'pickoff_caught_stealing_3b', 'pickoff_caught_stealing_home'), 1, 0) pickoffCaughtStealing,
  IF(eventType = 'pickoff_error_1b', 1, 0) pickoffErrorFirstBase,
  IF(eventType = 'pickoff_error_2b', 1, 0) pickoffErrorSecondBase,
  IF(eventType = 'pickoff_error_3b', 1, 0) pickoffErrorThirdBase,
  IF(eventType IN ('pickoff_error_1b', 'pickoff_error_2b', 'pickoff_error_3b'), 1, 0) pickoffErrors,
  IF(eventType = 'stolen_base_2b', 1, 0) stolenSecondBase,
  IF(eventType = 'stolen_base_3b', 1, 0) stolenThirdBase,
  IF(eventType = 'stolen_base_home', 1, 0) stolenHome,
  IF(eventType IN ('stolen_base_2b', 'stolen_base_3b', 'stolen_base_home'), 1, 0) stolenBases,
  IF(eventType = 'wild_pitch', 1, 0) wildPitches
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
                        )
  ;

COMMIT;

END //

DELIMITER ;
