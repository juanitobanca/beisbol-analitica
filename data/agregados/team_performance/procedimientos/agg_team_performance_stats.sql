USE baseball;

DROP PROCEDURE agg_team_performance_stats;

DELIMITER //

CREATE PROCEDURE agg_team_performance_stats( IN p_grouping_fields VARCHAR(255),
                                    IN p_aggregation_type VARCHAR(255),
                                    OUT insert_stmt VARCHAR(16000)
                                  )
BEGIN

/* Para probar este procedimiento hacer: CALL agg_team_performance_stats( 'majorLeagueId', @insert_stmt);  */

SET @insert_stmt = CONCAT('INSERT INTO agg_team_performance_stats(',
                            IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                            p_grouping_fields,',',
                           'aggregationType,
                            runs,
                            runsAllowed,
                            wins,
                            losses,
                            attendance,
                            groupingId,
                            groupingDescription
                            ) WITH g AS
                            (
                            SELECT
                                majorLeagueId,
                                seasonId,
                                gameDate,
                                gameType2,
                                "home" teamType,
                                venueId,
                                homeTeamId AS teamId,
                                homeScore runs,
                                awayScore runsAllowed,
                                homeWins wins,
                                homeLosses losses,
                                attendance
                                FROM games

                                UNION ALL

                            SELECT
                                majorLeagueId,
                                seasonId,
                                gameDate,
                                gameType2,
                                "away" teamType,
                                venueId,
                                awayTeamId AS teamId,
                                awayScore runs,
                                homeScore runsAllowed,
                                awayWins wins,
                                awayLosses losses,
                                attendance
                                FROM games
                            ), d AS
                            (
                                SELECT ',
                                IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                                p_grouping_fields,',',
                               'SUM(runs) AS runs,
                                SUM(runsAllowed) AS runsAllowed,
                                SUM(wins) AS wins,
                                SUM(losses) AS losses,
                                SUM(attendance) AS attendance
                                FROM g
                                WHERE gameType2 IN ( "RS", "PS" )
                                GROUP BY ',
                                IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                                p_grouping_fields,
                            ')
                            SELECT ',
                                IF( p_aggregation_type = 'CUMULATIVE', 'gameDate,',''),
                                p_grouping_fields, ',',
                                IF( p_aggregation_type = 'CUMULATIVE', '"CUMULATIVE",','"AGGREGATED",'),
                                AGG_OR_CUM_QUERIES('SUM(runs)', p_grouping_fields, p_aggregation_type ), ' AS runs,',
                                AGG_OR_CUM_QUERIES('SUM(runsAllowed)', p_grouping_fields, p_aggregation_type ), ' AS runsAllowed,',
                                AGG_OR_CUM_QUERIES('SUM(wins)', p_grouping_fields, p_aggregation_type ), ' AS wins,',
                                AGG_OR_CUM_QUERIES('SUM(losses)', p_grouping_fields, p_aggregation_type ), ' AS losses,',
                                AGG_OR_CUM_QUERIES('SUM(attendance)', p_grouping_fields, p_aggregation_type ), ' AS attendance,',
                                'agg_grouping_id("', p_grouping_fields, '") groupingId,
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
