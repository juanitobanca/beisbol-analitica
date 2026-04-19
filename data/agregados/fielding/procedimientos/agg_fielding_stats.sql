-- Procedure: agg_fielding_stats
-- NOTE: This procedure used dynamic SQL in MySQL. In SQLite, each grouping combination
-- must be called as a separate static SQL statement from the application layer.
-- The template query is preserved below as a reference.

-- Parameters were: p_grouping_fields VARCHAR(255), p_aggregation_type VARCHAR(255)

/*
INSERT INTO agg_fielding_stats (
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields},
    aggregationType,
    assists, catcherInterferences, errors, games, putOuts, totalChances, outsPlayed,
    groupingId, groupingDescription
)
WITH stats AS
(
    SELECT
        majorLeagueId, seasonId, gameDate, gameType2, venueId, positionAbbrev,
        CASE WHEN halfInning = "top" THEN "home" ELSE "away" END AS teamType,
        CASE WHEN halfInning = "top" THEN homeTeamId ELSE awayTeamId END AS teamId,
        g.gamePk, playerId,
        CASE WHEN credit LIKE "%assist%" THEN 1 ELSE 0 END AS assists,
        CASE WHEN credit = "c_catcher_interf" THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN credit LIKE "%error%" THEN 1 ELSE 0 END AS errors,
        CASE WHEN credit = "f_putout" THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc
        ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE gameType2 IN ("PS","RS")
),
outs AS
(
    SELECT gamePk outsGamePk, playerId outsPlayerId, positionAbbrev outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS
(
    SELECT
        -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
        {p_grouping_fields},
        SUM( assists ) assists,
        SUM( catcherInterferences ) catcherInterferences,
        SUM( errors ) errors,
        COUNT(DISTINCT gamePk) games,
        SUM( putOuts ) putOuts,
        SUM( assists + catcherInterferences + errors + putOuts ) totalChances,
        SUM( outs ) outsPlayed
    FROM stats s
    INNER JOIN  outs o
        ON s.gamePk = o.outsGamePk
        AND s.playerId = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
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
    SUM( assists ) assists,
    SUM( catcherInterferences ) catcherInterferences,
    SUM( errors ) errors,
    SUM( games ) games,
    SUM( putOuts ) putOuts,
    SUM( totalChances ) totalChances,
    SUM( outsPlayed ) outsPlayed,
    -- NOTE: agg_grouping_id() was a MySQL UDF - replace with appropriate grouping id value
    -- NOTE: agg_grouping_description() was a MySQL UDF - replace with appropriate grouping description value
    {groupingId} AS groupingId,
    {groupingDescription} AS groupingDescription
FROM d
GROUP BY
    -- IF p_aggregation_type = 'CUMULATIVE': gameDate,
    {p_grouping_fields}
*/
