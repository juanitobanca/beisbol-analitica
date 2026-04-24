-- Procedure: major_leagues
INSERT INTO major_leagues(
    majorLeagueId,
    majorLeague
)
SELECT DISTINCT majorLeagueId, majorLeague
FROM games
WHERE majorLeagueId NOT IN (
    SELECT majorLeagueId
    FROM major_leagues
);
