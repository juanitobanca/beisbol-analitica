USE baseball;

DROP FUNCTION agg_grouping_id;

DELIMITER //

CREATE FUNCTION agg_grouping_id( p_grouping_fields VARCHAR(255) )
RETURNS INTEGER UNSIGNED
DETERMINISTIC
BEGIN

    /* Para probar esta funcion hacer: SELECT agg_grouping_id( 'majorLeagueId,seasonId'); */

    /* Si se necesita un nuevo campo de agracion, anyadirlo al inicio */
    DECLARE all_grouping_fields VARCHAR(255) DEFAULT 'opposingTeamId,officialId,pitchHand,batSide,positionAbbrev,halfInning,menOnBase,battingTeamId,pitchingTeamId,inning,runnersBeforePlay,outs,majorLeagueId,seasonId,gameType2,teamType,venueId,teamId,playerId';

    DECLARE grouping_id VARCHAR(20) DEFAULT '';
    DECLARE gf VARCHAR(30);

    /* Recorrer all_grouping_fields, extraer campo por campo(gf). Si gf existe
       en p_grouping_fields, agregar 1 a grouping_id, sino, 0. Al final se convierte
       grouping_id a decimal. */

    WHILE LENGTH(all_grouping_fields) > 0
    DO

        SET gf = SUBSTRING_INDEX(all_grouping_fields, ',', 1);
        SET all_grouping_fields = REPLACE(all_grouping_fields, gf, '');
        SET all_grouping_fields = TRIM(LEADING ',' FROM all_grouping_fields );

        IF FIND_IN_SET(gf, p_grouping_fields) > 0 THEN
            SET grouping_id = CONCAT(grouping_id,'1');
        ELSE
            SET grouping_id = CONCAT(grouping_id,'0');
        END IF;

    END WHILE;

    RETURN CONV(grouping_id,2,10);

END //

DELIMITER ;
