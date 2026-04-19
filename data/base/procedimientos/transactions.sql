-- Procedure: transactions
INSERT INTO transactions(
    transactionId,
    personId,
    toTeamId,
    teamId,
    transactionDate,
    effectiveDate,
    resolutionDate,
    typeCode,
    typeDesc,
    description
  )
SELECT DISTINCT
  id,
  personId,
  toTeamId,
  teamId,
  transactionDate,
  effectiveDate,
  resolutionDate,
  typeCode,
  typeDesc,
  description
FROM stg_transactions
WHERE
  1 = 1
  AND (id) NOT IN (
    SELECT
      transactionId
    FROM transactions
  );
