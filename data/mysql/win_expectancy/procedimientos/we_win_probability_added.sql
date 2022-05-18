USE baseball;

DROP PROCEDURE we_win_probability_added;

DELIMITER //

CREATE PROCEDURE we_win_probability_added( IN p_fields VARCHAR(255), IN p_grouping_fields VARCHAR(255), OUT insert_stmt VARCHAR(16000) )
BEGIN

SET @insert_stmt = CONCAT('INSERT INTO we_win_probability_added (', p_grouping_fields, ',',
                          ' offensiveWinProbabilityAdded,
                            defensiveWinProbabilityAdded,
                            groupingId,
                            groupingDescription,
                            groupingFields
                          )
                          WITH we AS (
                            -- Win Expectancy, tomando todas las temporadas existentes, desde la perspectiva del bateador
                            SELECT
                              majorLeagueId,
                              -- Hay poca informacion para extra innings, agregando extra innings como 10
                              IF(inning > 9, 10, inning) AS inning,
                              menOnBase,
                              outs,
                              score,
                              SUM(wins) / SUM(games) AS winExpectancy
                            FROM we_win_expectancy
                            WHERE
                              groupingDescription = "MAJORLEAGUEID_SEASONID_INNING_GAMETYPE2_MENONBASE_OUTS"
                              AND gameType2 = "RS"
                            GROUP BY
                              1, 2, 3, 4, 5
                          ),
                          pbp AS (
                            /* Play by Play. Aqui estamos asumiendo que el pitcher responsable es el pitcher en juego.
                            Este pitcher puede ser responsable o no de que esten los jugadores en base*/
                            SELECT
                              majorLeagueId,
                              seasonId,
                              gameType2,
                              battingTeamId,
                              pitchingTeamId,
                              batterId,
                              batSide,
                              runnerId,
                              pitcherId,
                              pitchHand,
                              menOnBaseBeforePlay,
                              outsBeforePlay,
                              -- Hay poca informacion para extra innings, agregando extra innings como 10
                              IF(inning > 9, 10, inning) AS inning,
                              CASE
                                WHEN battingTeamScore - pitchingTeamScore < 0 THEN "LOSING"
                                WHEN battingTeamScore - pitchingTeamScore > 0 THEN "WINNING"
                                ELSE "TIE"
                              END AS scoreBeforePlay,
                              -- Hay un pequenio bug en rem_play_by_play en el que a veces el numero de outsAfterPlay > 3
                              IF(outsAfterPlay >= 3, 3, outsAfterPlay) outsAfterPlay,
                              CASE
                                WHEN (battingTeamScore + runsScoredInPlay) - pitchingTeamScore < 0 THEN "LOSING"
                                WHEN (battingTeamScore + runsScoredInPlay) - pitchingTeamScore > 0 THEN "WINNING"
                                ELSE "TIE"
                              END scoreAfterPlay,
                              -- Cuando hay 3 outs, entonces el nuevo estado de corredores en base es Empty
                              "Empty" AS menOnBaseAfterPlay
                            FROM rem_play_by_play
                          ),
                          data AS (
                            SELECT
                              pbp.majorLeagueId,
                              pbp.seasonId,
                              pbp.gameType2,
                              pbp.battingTeamId,
                              pbp.pitchingTeamId,
                              pbp.batterId,
                              pbp.batSide,
                              pbp.pitcherId,
                              pbp.pitchHand,
                              pbp.runnerId,
                              a.winExpectancy - b.winExpectancy AS offensiveWinProbabilityAdded,
                              -1 * (a.winExpectancy - b.winExpectancy) AS defensiveWinProbabilityAdded
                            FROM pbp
                            INNER JOIN we b
                              ON pbp.majorLeagueId = b.majorLeagueId
                              AND pbp.inning = b.inning
                              AND pbp.menOnBaseBeforePlay = b.menOnBase
                              AND pbp.outsBeforePlay = b.outs
                              AND pbp.scoreBeforePlay = b.score
                            INNER JOIN we a
                              ON pbp.majorLeagueId = a.majorLeagueId
                              AND pbp.inning = a.inning
                              AND pbp.menOnBaseAfterPlay = a.menOnBase
                              AND pbp.outsAfterPlay = a.outs
                              AND pbp.scoreAfterPlay = a.score
                          )
                          SELECT ', p_fields, ',',
                          ' SUM(offensiveWinProbabilityAdded) offensiveWinProbabilityAdded,
                            SUM(defensiveWinProbabilityAdded) defensiveWinProbabilityAdded,
                            agg_grouping_id("', p_grouping_fields, '") groupingId,
                            agg_grouping_description("', p_grouping_fields, '") groupingDescription,
                            agg_grouping_description("', p_fields, '") groupingFields
                          FROM data
                          WHERE ', IF( p_fields LIKE '%batterId%', 'runnerId Is Null', 'TRUE' ),
                          ' AND ', IF( p_fields LIKE '%runnerId%' , 'runnerId Is Not Null', 'TRUE' ),
                          ' GROUP BY ', p_fields
                        );

SELECT @insert_stmt;
PREPARE insert_stmt_sql FROM @insert_stmt;
EXECUTE insert_stmt_sql;


COMMIT;

END //

DELIMITER ;
