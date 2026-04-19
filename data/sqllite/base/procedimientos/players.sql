-- Procedure: players
INSERT INTO players(
    playerId,
    firstName,
    lastName,
    fullName,
    birthDate,
    birthCity,
    birthStateProvince,
    birthCountry,
    strikeZoneTop,
    strikeZoneBottom,
    positionAbbrev,
    batSide,
    pitchHand
  )
SELECT DISTINCT
  id playerId,
  firstName,
  lastName,
  (firstName || ' ' || lastName) AS fullName,
  birthDate,
  birthCity,
  birthStateProvince,
  birthCountry,
  strikeZoneTop,
  strikeZoneBottom,
  abbreviation,
  batSideCode batSide,
  pitchHandCode pitchHand
FROM stg_players
WHERE
  1 = 1
  AND id IS NOT NULL
  AND id NOT IN (
    SELECT
      playerId
    FROM players
  );
