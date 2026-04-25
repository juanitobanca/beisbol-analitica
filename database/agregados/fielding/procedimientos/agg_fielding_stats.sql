-- ============================================================
-- agg_fielding_stats cube — SQLite3 static equivalent
-- Run with:  sqlite3 your_base.db < agg_fielding_stats.sql
-- ============================================================

BEGIN;

-- ── Grouping 4186695649: MAJORLEAGUEID_SEASONID_GAMETYPE2 ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        teamType,
        playerId,
        venueId,
        aggregationType,
        assists,
        catcherInterferences,
        errors,
        games,
        putOuts,
        totalChances,
        outsPlayed,
        groupingId,
        groupingDescription
)
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        s.majorLeagueId,
        s.seasonId,
        s.gameType2,
        NULL AS positionAbbrev,
        NULL AS teamId,
        NULL AS teamType,
        NULL AS playerId,
        NULL AS venueId,
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY majorLeagueId, seasonId, gameType2
)
SELECT
        majorLeagueId,
        seasonId,
        gameType2,
        NULL AS positionAbbrev,
        NULL AS teamId,
        NULL AS teamType,
        NULL AS playerId,
        NULL AS venueId,
        SUM(assists)              AS assists,
        SUM(catcherInterferences) AS catcherInterferences,
        SUM(errors)               AS errors,
        SUM(games)                AS games,
        SUM(putOuts)              AS putOuts,
        SUM(totalChances)         AS totalChances,
        SUM(outsPlayed)           AS outsPlayed,
        'AGGREGATED' AS aggregationType,
        4186695649        AS groupingId,
        'MAJORLEAGUEID_SEASONID_GAMETYPE2'    AS groupingDescription
FROM d
GROUP BY majorLeagueId, seasonId, gameType2;


-- ── Grouping 2010157492: MAJORLEAGUEID_SEASONID_GAMETYPE2_POSITIONABBREV_PLAYERID ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        teamType,
        playerId,
        venueId,
        aggregationType,
        assists,
        catcherInterferences,
        errors,
        games,
        putOuts,
        totalChances,
        outsPlayed,
        groupingId,
        groupingDescription
)
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        s.majorLeagueId,
        s.seasonId,
        s.gameType2,
        s.positionAbbrev,
        NULL AS teamId,
        NULL AS teamType,
        s.playerId,
        NULL AS venueId,
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY majorLeagueId, seasonId, gameType2, positionAbbrev, playerId
)
SELECT
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        NULL AS teamId,
        NULL AS teamType,
        playerId,
        NULL AS venueId,
        SUM(assists)              AS assists,
        SUM(catcherInterferences) AS catcherInterferences,
        SUM(errors)               AS errors,
        SUM(games)                AS games,
        SUM(putOuts)              AS putOuts,
        SUM(totalChances)         AS totalChances,
        SUM(outsPlayed)           AS outsPlayed,
        'AGGREGATED' AS aggregationType,
        2010157492        AS groupingId,
        'MAJORLEAGUEID_SEASONID_GAMETYPE2_POSITIONABBREV_PLAYERID'    AS groupingDescription
FROM d
GROUP BY majorLeagueId, seasonId, gameType2, positionAbbrev, playerId;


-- ── Grouping 3215925615: MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        teamType,
        playerId,
        venueId,
        aggregationType,
        assists,
        catcherInterferences,
        errors,
        games,
        putOuts,
        totalChances,
        outsPlayed,
        groupingId,
        groupingDescription
)
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        s.majorLeagueId,
        s.seasonId,
        s.gameType2,
        NULL AS positionAbbrev,
        s.teamId,
        NULL AS teamType,
        NULL AS playerId,
        NULL AS venueId,
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY majorLeagueId, seasonId, gameType2, teamId
)
SELECT
        majorLeagueId,
        seasonId,
        gameType2,
        NULL AS positionAbbrev,
        teamId,
        NULL AS teamType,
        NULL AS playerId,
        NULL AS venueId,
        SUM(assists)              AS assists,
        SUM(catcherInterferences) AS catcherInterferences,
        SUM(errors)               AS errors,
        SUM(games)                AS games,
        SUM(putOuts)              AS putOuts,
        SUM(totalChances)         AS totalChances,
        SUM(outsPlayed)           AS outsPlayed,
        'AGGREGATED' AS aggregationType,
        3215925615        AS groupingId,
        'MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID'    AS groupingDescription
FROM d
GROUP BY majorLeagueId, seasonId, gameType2, teamId;


-- ── Grouping 3253299964: MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID_POSITIONABBREV_PLAYERID ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        teamType,
        playerId,
        venueId,
        aggregationType,
        assists,
        catcherInterferences,
        errors,
        games,
        putOuts,
        totalChances,
        outsPlayed,
        groupingId,
        groupingDescription
)
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        s.majorLeagueId,
        s.seasonId,
        s.gameType2,
        s.positionAbbrev,
        s.teamId,
        NULL AS teamType,
        s.playerId,
        NULL AS venueId,
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY majorLeagueId, seasonId, gameType2, teamId, positionAbbrev, playerId
)
SELECT
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        NULL AS teamType,
        playerId,
        NULL AS venueId,
        SUM(assists)              AS assists,
        SUM(catcherInterferences) AS catcherInterferences,
        SUM(errors)               AS errors,
        SUM(games)                AS games,
        SUM(putOuts)              AS putOuts,
        SUM(totalChances)         AS totalChances,
        SUM(outsPlayed)           AS outsPlayed,
        'AGGREGATED' AS aggregationType,
        3253299964        AS groupingId,
        'MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID_POSITIONABBREV_PLAYERID'    AS groupingDescription
FROM d
GROUP BY majorLeagueId, seasonId, gameType2, teamId, positionAbbrev, playerId;


-- ── Grouping 169487603: MAJORLEAGUEID_SEASONID_GAMETYPE2_VENUEID_TEAMID_TEAMTYPE ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        teamType,
        playerId,
        venueId,
        aggregationType,
        assists,
        catcherInterferences,
        errors,
        games,
        putOuts,
        totalChances,
        outsPlayed,
        groupingId,
        groupingDescription
)
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        s.majorLeagueId,
        s.seasonId,
        s.gameType2,
        NULL AS positionAbbrev,
        s.teamId,
        s.teamType,
        NULL AS playerId,
        s.venueId,
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY majorLeagueId, seasonId, gameType2, venueId, teamId, teamType
)
SELECT
        majorLeagueId,
        seasonId,
        gameType2,
        NULL AS positionAbbrev,
        teamId,
        teamType,
        NULL AS playerId,
        venueId,
        SUM(assists)              AS assists,
        SUM(catcherInterferences) AS catcherInterferences,
        SUM(errors)               AS errors,
        SUM(games)                AS games,
        SUM(putOuts)              AS putOuts,
        SUM(totalChances)         AS totalChances,
        SUM(outsPlayed)           AS outsPlayed,
        'AGGREGATED' AS aggregationType,
        169487603        AS groupingId,
        'MAJORLEAGUEID_SEASONID_GAMETYPE2_VENUEID_TEAMID_TEAMTYPE'    AS groupingDescription
FROM d
GROUP BY majorLeagueId, seasonId, gameType2, venueId, teamId, teamType;


-- ── Grouping 1730332978: MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID_TEAMTYPE ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        majorLeagueId,
        seasonId,
        gameType2,
        positionAbbrev,
        teamId,
        teamType,
        playerId,
        venueId,
        aggregationType,
        assists,
        catcherInterferences,
        errors,
        games,
        putOuts,
        totalChances,
        outsPlayed,
        groupingId,
        groupingDescription
)
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        s.majorLeagueId,
        s.seasonId,
        s.gameType2,
        NULL AS positionAbbrev,
        s.teamId,
        s.teamType,
        NULL AS playerId,
        NULL AS venueId,
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY majorLeagueId, seasonId, gameType2, teamId, teamType
)
SELECT
        majorLeagueId,
        seasonId,
        gameType2,
        NULL AS positionAbbrev,
        teamId,
        teamType,
        NULL AS playerId,
        NULL AS venueId,
        SUM(assists)              AS assists,
        SUM(catcherInterferences) AS catcherInterferences,
        SUM(errors)               AS errors,
        SUM(games)                AS games,
        SUM(putOuts)              AS putOuts,
        SUM(totalChances)         AS totalChances,
        SUM(outsPlayed)           AS outsPlayed,
        'AGGREGATED' AS aggregationType,
        1730332978        AS groupingId,
        'MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID_TEAMTYPE'    AS groupingDescription
FROM d
GROUP BY majorLeagueId, seasonId, gameType2, teamId, teamType;


COMMIT;
