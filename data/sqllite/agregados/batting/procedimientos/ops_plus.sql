USE baseball;

DROP PROCEDURE ops_plus;

DELIMITER //

CREATE PROCEDURE ops_plus( )
BEGIN

/* Se puede generar codigo dinamico que calcule datos a distintos niveles. Por ejemplo
para que unicamente compare zurdos contra zurdos o situaciones menOnBase, etc. */

UPDATE
  agg_batting_stats a
INNER JOIN
(
  SELECT majorLeagueId, seasonId, gameType2,
          onBasePercentage AS leagueOnBasePercentage,
          sluggingPercentage AS leagueSluggingPercentage
    FROM agg_batting_stats
    WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
    AND   aggregationType = 'AGGREGATED'
    AND   gameType2 = 'RS'
) l
ON a.majorLeagueId = l.majorLeagueId
AND a.seasonId = l.seasonId
AND a.gameType2 = l.gameType2
SET a.leagueOnBasePercentage = l.leagueOnBasePercentage,
    a.leagueSluggingPercentage = l.leagueSluggingPercentage
WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
AND aggregationType = 'AGGREGATED';


UPDATE agg_batting_stats
    SET onBasePlusSluggingPercentagePlus = onBasePercentage / leagueOnBasePercentage + sluggingPercentage / leagueSluggingPercentage - 1
WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
AND   aggregationType = 'AGGREGATED';

COMMIT;

END //

DELIMITER ;
