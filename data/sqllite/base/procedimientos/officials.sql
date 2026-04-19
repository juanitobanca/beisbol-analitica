-- Procedure: officials
INSERT INTO officials(
    officialId,
    firstName,
    lastName,
    birthDate,
    birthCity,
    birthStateProvince,
    birthCountry
  )
SELECT DISTINCT
  id officialId,
  firstName,
  lastName,
  birthDate,
  birthCity,
  birthStateProvince,
  birthCountry
FROM stg_officials
WHERE
  1 = 1
  AND id IS NOT NULL
  AND id NOT IN (
    SELECT
      officialId
    FROM officials
  );
