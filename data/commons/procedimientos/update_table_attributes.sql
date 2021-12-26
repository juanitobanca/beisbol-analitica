USE baseball;

DROP PROCEDURE update_table_attributes;

DELIMITER //

CREATE PROCEDURE update_table_attributes( IN tbl VARCHAR(255), OUT update_stmt VARCHAR(16000) )
BEGIN

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;

   SET @update_stmt = CONCAT('UPDATE ',tbl, ' AS tbl
                              LEFT JOIN (
                                 SELECT DISTINCT majorLeagueId, majorLeague
                                 FROM games
                                 ) m
                              ON tbl.majorLeagueId = m.majorLeagueId
                              SET tbl.majorLeagueName = m.majorLeague;'
                           );
   SELECT @update_stmt;
   PREPARE update_stmt_sql FROM @update_stmt;
   EXECUTE update_stmt_sql;

   SET @update_stmt = CONCAT('UPDATE ',tbl, ' AS tbl
                              LEFT JOIN (
                                 SELECT DISTINCT playerId, CONCAT( firstName, " ", lastName ) playerName
                                 FROM players
                                 ) p
                              ON tbl.playerId = p.playerId
                              SET tbl.playerName = p.playerName;'
                           );
   SELECT @update_stmt;
   PREPARE update_stmt_sql FROM @update_stmt;
   EXECUTE update_stmt_sql;

   SET @update_stmt = CONCAT('UPDATE ',tbl, ' AS tbl
                              LEFT JOIN (
                                 SELECT DISTINCT majorLeagueId, seasonId, homeTeamId teamId, homeTeamName teamName
                                 FROM games
                                 ) t
                              ON tbl.majorLeagueId = t.majorLeagueId
                              AND tbl.seasonId = t.seasonId
                              AND tbl.teamId = t.teamId
                              SET tbl.teamName = t.teamName'
                           );
   SELECT @update_stmt;
   PREPARE update_stmt_sql FROM @update_stmt;
   EXECUTE update_stmt_sql;

   SET @update_stmt = CONCAT('UPDATE ',tbl, ' AS tbl
                              LEFT JOIN (
                                 SELECT DISTINCT majorLeagueId, seasonId, venueId, venueName
                                 FROM games
                                 ) v
                              ON tbl.venueId = v.venueId
                              SET tbl.venueName = v.venueName'
                           );
   SELECT @update_stmt;
   PREPARE update_stmt_sql FROM @update_stmt;
   EXECUTE update_stmt_sql;

   SET @update_stmt = CONCAT('UPDATE ',tbl, ' AS tbl
                              LEFT JOIN (
                                 SELECT DISTINCT officialId, CONCAT( firstName, " ", lastName ) officialName
                                 FROM officials
                                 ) p
                              ON tbl.officialId = p.officialId
                              SET tbl.officialName = p.officialName;'
                           );
   SELECT @update_stmt;
   PREPARE update_stmt_sql FROM @update_stmt;
   EXECUTE update_stmt_sql;

   SET @update_stmt = CONCAT('UPDATE ',tbl, ' AS tbl
                              LEFT JOIN (
                                 SELECT DISTINCT majorLeagueId, seasonId, homeTeamId teamId, homeTeamName opposingTeamName
                                 FROM games
                                 ) t
                              ON tbl.majorLeagueId = t.majorLeagueId
                              AND tbl.seasonId = t.seasonId
                              AND tbl.teamId = t.teamId
                              SET tbl.opposingTeamName = t.opposingTeamName'
                           );
   SELECT @update_stmt;
   PREPARE update_stmt_sql FROM @update_stmt;
   EXECUTE update_stmt_sql;

END //

DELIMITER ;
