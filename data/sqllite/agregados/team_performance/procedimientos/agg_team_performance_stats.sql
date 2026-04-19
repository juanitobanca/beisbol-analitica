-- Procedure: agg_team_performance_stats
-- NOTE: This procedure used dynamic SQL in MySQL. In SQLite, each grouping combination
-- must be called as a separate static SQL statement from the application layer.
-- The template query is preserved below as a reference.

-- Parameters were: p_grouping_fields VARCHAR(255), p_aggregation_type VARCHAR(255)

/*
INSERT INTO agg_team_performance_stats(
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields},
    aggregationType,
    runs, runsAllowed, wins, losses, attendance,
    groupingId, groupingDescription
)
WITH g AS
(
    SELECT
        majorLeagueId, seasonId, gameDate, gameType2,
        "home" teamType, venueId,
        homeTeamId AS teamId,
        homeScore runs, awayScore runsAllowed,
        CASE WHEN homeIsWinner = 1 THEN 1 ELSE 0 END AS wins,
        CASE WHEN awayIsWinner = 1 THEN 1 ELSE 0 END AS losses,
        attendance
    FROM games

    UNION ALL

    SELECT
        majorLeagueId, seasonId, gameDate, gameType2,
        "away" teamType, venueId,
        awayTeamId AS teamId,
        awayScore runs, homeScore runsAllowed,
        CASE WHEN awayIsWinner = 1 THEN 1 ELSE 0 END AS wins,
        CASE WHEN homeIsWinner = 1 THEN 1 ELSE 0 END AS losses,
        attendance
    FROM games
),
d AS
(
    SELECT
        -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
        {p_grouping_fields},
        SUM(runs) AS runs,
        SUM(runsAllowed) AS runsAllowed,
        SUM(wins) AS wins,
        SUM(losses) AS losses,
        SUM(attendance) AS attendance
    FROM g
    WHERE gameType2 IN ( "RS", "PS" )
    GROUP BY
        -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
        {p_grouping_fields}
)
SELECT
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields},
    -- IF p_aggregation_type = 'CUMULATIVE': "CUMULATIVE", ELSE: "AGGREGATED",
    -- NOTE: AGG_OR_CUM_QUERIES() was a MySQL UDF that generated SUM() or cumulative SUM() OVER() expressions
    -- For AGGREGATED: use SUM(col) directly
    -- For CUMULATIVE: use SUM(SUM(col)) OVER (PARTITION BY {p_grouping_fields} ORDER BY gameDate)
    SUM(runs) AS runs,
    SUM(runsAllowed) AS runsAllowed,
    SUM(wins) AS wins,
    SUM(losses) AS losses,
    SUM(attendance) AS attendance,
    -- NOTE: agg_grouping_id() was a MySQL UDF - replace with appropriate grouping id value
    -- NOTE: agg_grouping_description() was a MySQL UDF - replace with appropriate grouping description value
    {groupingId} AS groupingId,
    {groupingDescription} AS groupingDescription
FROM d
GROUP BY
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields}
*/
