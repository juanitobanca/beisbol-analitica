USE baseball;

DROP PROCEDURE defensive_substitutions;

DELIMITER //

CREATE PROCEDURE defensive_substitutions()
BEGIN

  INSERT INTO defensive_substitutions(
      gamePk,
      atBatIndex,
      playIndex,
      substitutionAtBatIndex,
      substitutionPlayIndex
    )
    WITH subs AS (
      /* Eventos de sustitucion */
      SELECT
        gamePk,
        pitchingTeamId,
        atBatIndex,
        playIndex,
        positionAbbrev
      FROM actions
      WHERE
        event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')
        AND positionAbbrev IS NOT NULL
        AND gamePk NOT IN (
          SELECT
            gamePk
          FROM defensive_substitutions
        )
    ),
    subs_indexes AS (
      /* Obtener el atBatIndex y playIndex de la sustitutcion */
      SELECT
        n.gamePk,
        n.atBatIndex,
        n.playIndex,
        MIN(a.atBatIndex + a.playIndex * .1) substitutionIndexes
      FROM subs n
      LEFT JOIN subs a
        ON n.gamePk = a.gamePk
        AND n.pitchingTeamId = a.pitchingTeamId
        AND n.positionAbbrev = a.positionAbbrev
        AND (
          n.atBatIndex < a.atBatIndex
          OR (
            n.atBatIndex = a.atBatIndex
            AND n.playIndex < a.playIndex
          )
        )
      GROUP BY
        1, 2, 3
    )
  SELECT
    gamePk,
    atBatIndex,
    playIndex,
    CAST(
      SUBSTR(substitutionIndexes, 1, Instr(substitutionIndexes, '.') - 1) AS UNSIGNED
    ) substitutionAtBatIndex,
    CAST(SUBSTR(substitutionIndexes, Instr(substitutionIndexes, '.') + 1) AS UNSIGNED) substitutionPlayIndex
  FROM subs_indexes;

  /* Actualizar datos de la sustitucion */
  UPDATE
    defensive_substitutions ds
  INNER JOIN (
    SELECT
      gamePk,
      atBatIndex,
      playIndex,
      inning,
      halfInning,
      battingTeamId,
      pitchingTeamId,
      playerId,
      positionAbbrev,
      endOuts AS outs
    FROM actions
    WHERE
      event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')
  ) a
    ON ds.gamePk = a.gamePk
    AND ds.atBatIndex = a.atBatIndex
    AND ds.playIndex = a.playIndex
    SET ds.inning = a.inning
    ,   ds.halfInning = a.halfInning
    ,   ds.battingTeamId = a.battingTeamId
    ,   ds.pitchingTeamId = a.pitchingTeamId
    ,   ds.playerId = a.playerId
    ,   ds.positionAbbrev = a.positionAbbrev
    ,   ds.outs = a.outs;

  /* Actualizar datos del jugador que sustituye */
  UPDATE
    defensive_substitutions ds
  INNER JOIN (
    SELECT
      gamePk,
      atBatIndex,
      playIndex,
      playerId,
      inning,
      endOuts AS outs
    FROM actions
    WHERE
      event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')
  ) a
    ON ds.gamePk = a.gamePk
    AND ds.substitutionAtBatIndex = a.atBatIndex
    AND ds.substitutionPlayIndex = a.playIndex
    SET ds.substitutingPlayerId = a.playerId
    ,   ds.substitutingInning = a.inning
    ,   ds.substitutingOuts = a.outs;

COMMIT;

END //

DELIMITER ;
