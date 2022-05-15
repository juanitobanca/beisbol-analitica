USE baseball;

DROP PROCEDURE agg_fielding_stats;

DELIMITER //

CREATE PROCEDURE agg_fielding_stats( IN p_grouping_fields VARCHAR(255),
                                     IN p_aggregation_type VARCHAR(255),
                                     OUT insert_stmt VARCHAR(16000)
                                  )
BEGIN

/* Para probar este procedimiento hacer: CALL agg_fielding_stats( 'majorLeagueId', @insert_stmt);  */

SET @insert_stmt = CONCAT('INSERT INTO agg_fielding_stats (',
                            IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                            p_grouping_fields,',',
                          ' aggregationType,
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
                            WITH stats AS
                            (
                              /* PutOuts, asistencias, etc */
                              SELECT
                              majorLeagueId
                            , seasonId
                            , gameDate
                            , gameType2
                            , venueId
                            , positionAbbrev
                            , IF( halfInning = "top", "home", "away" ) teamType
                            , IF( halfInning = "top", homeTeamId, awayTeamId ) teamId
                            , g.gamePk
                            , playerId
                            , IF( credit LIKE "%assist%", 1, 0 ) assists
                            , IF( credit = "c_catcher_interf", 1, 0 ) catcherInterferences
                            , IF( credit LIKE "%error%", 1,  0 ) errors
                            , IF( credit = "f_putout", 1, 0 ) putOuts
 						                FROM games g
                            INNER JOIN fielding_credits fc
                                ON g.gamePk = fc.gamePk
                            INNER JOIN atbats a
                                ON fc.gamePk = a.gamePk
                                AND fc.atBatIndex = a.atBatIndex
                            WHERE gameType2 IN ("PS","RS")
                            ), outs AS
                            (
                              /* Outs, renombrar variables para agrupaciones */
                              SELECT gamePk outsGamePk, playerId outsPlayerId, positionAbbrev outsPositionAbbrev, outs
                              FROM game_player_fielding_outs
                            ), d AS
                            (
                            SELECT ',
                            IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                            p_grouping_fields, ',',
                          ' SUM( assists ) assists,
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
                            GROUP BY ',
                                IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                                p_grouping_fields,
                            ')
                            SELECT ',
                            IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                            p_grouping_fields, ',',
                            IF( p_aggregation_type = 'CUMULATIVE', '"CUMULATIVE",','"AGGREGATED",'),
                            AGG_OR_CUM_QUERIES('SUM( assists )', p_grouping_fields, p_aggregation_type ),' assists,',
                            AGG_OR_CUM_QUERIES('SUM( catcherInterferences )', p_grouping_fields, p_aggregation_type ),' catcherInterferences,',
                            AGG_OR_CUM_QUERIES('SUM( errors )', p_grouping_fields, p_aggregation_type ),' errors,',
                            AGG_OR_CUM_QUERIES('SUM( games )', p_grouping_fields, p_aggregation_type ),' games,',
                            AGG_OR_CUM_QUERIES('SUM( putOuts )', p_grouping_fields, p_aggregation_type ),' putOuts,',
                            AGG_OR_CUM_QUERIES('SUM( totalChances )', p_grouping_fields, p_aggregation_type ),' totalChances,',
                            AGG_OR_CUM_QUERIES('SUM( outsPlayed )', p_grouping_fields, p_aggregation_type ),' outsPlayed,',
                          ' agg_grouping_id("', p_grouping_fields, '") groupingId,
                            agg_grouping_description("', p_grouping_fields, '") groupingDescription
                            FROM d
                            GROUP BY ',
                                IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                                p_grouping_fields
                           );
SELECT @insert_stmt;
PREPARE insert_stmt_sql FROM @insert_stmt;
EXECUTE insert_stmt_sql;

END //

DELIMITER ;
