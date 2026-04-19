-- Procedure: defensive_substitutions
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
      SUBSTR(substitutionIndexes, 1, Instr(substitutionIndexes, '.') - 1) AS INTEGER
    ) substitutionAtBatIndex,
    CAST(SUBSTR(substitutionIndexes, Instr(substitutionIndexes, '.') + 1) AS INTEGER) substitutionPlayIndex
  FROM subs_indexes;

  /* Actualizar datos de la sustitucion */
  UPDATE defensive_substitutions
  SET inning         = (SELECT a.inning FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      halfInning     = (SELECT a.halfInning FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      battingTeamId  = (SELECT a.battingTeamId FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      pitchingTeamId = (SELECT a.pitchingTeamId FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      playerId       = (SELECT a.playerId FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      positionAbbrev = (SELECT a.positionAbbrev FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      outs           = (SELECT a.endOuts FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution'))
  WHERE EXISTS (SELECT 1 FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.atBatIndex = a.atBatIndex AND defensive_substitutions.playIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution'));

  /* Actualizar datos del jugador que sustituye */
  UPDATE defensive_substitutions
  SET substitutingPlayerId = (SELECT a.playerId FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.substitutionAtBatIndex = a.atBatIndex AND defensive_substitutions.substitutionPlayIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      substitutingInning   = (SELECT a.inning FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.substitutionAtBatIndex = a.atBatIndex AND defensive_substitutions.substitutionPlayIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution')),
      substitutingOuts     = (SELECT a.endOuts FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.substitutionAtBatIndex = a.atBatIndex AND defensive_substitutions.substitutionPlayIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution'))
  WHERE EXISTS (SELECT 1 FROM actions a WHERE defensive_substitutions.gamePk = a.gamePk AND defensive_substitutions.substitutionAtBatIndex = a.atBatIndex AND defensive_substitutions.substitutionPlayIndex = a.playIndex AND a.event IN ('Defensive Sub', 'Defensive Switch', 'Pitching Substitution'));
