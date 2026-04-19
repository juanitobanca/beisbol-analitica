USE baseball;

DROP FUNCTION agg_grouping_description;

DELIMITER //

CREATE FUNCTION agg_grouping_description( p_grouping_fields VARCHAR(255) )
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN

    RETURN UPPER(REPLACE(p_grouping_fields,',','_'));

END //

DELIMITER ;
