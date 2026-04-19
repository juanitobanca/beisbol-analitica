USE baseball;

DROP PROCEDURE major_leagues;

DELIMITER //

CREATE PROCEDURE major_leagues()
BEGIN

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

COMMIT;

END //

DELIMITER ;
