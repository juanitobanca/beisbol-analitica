-- Procedure: ops_plus

/* Se puede generar codigo dinamico que calcule datos a distintos niveles. Por ejemplo
para que unicamente compare zurdos contra zurdos o situaciones menOnBase, etc. */

UPDATE agg_batting_stats
SET leagueOnBasePercentage = (
      SELECT onBasePercentage
      FROM agg_batting_stats l
      WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND l.aggregationType = 'AGGREGATED'
        AND l.gameType2 = 'RS'
        AND l.majorLeagueId = agg_batting_stats.majorLeagueId
        AND l.seasonId = agg_batting_stats.seasonId
        AND l.gameType2 = agg_batting_stats.gameType2
    ),
    leagueSluggingPercentage = (
      SELECT sluggingPercentage
      FROM agg_batting_stats l
      WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND l.aggregationType = 'AGGREGATED'
        AND l.gameType2 = 'RS'
        AND l.majorLeagueId = agg_batting_stats.majorLeagueId
        AND l.seasonId = agg_batting_stats.seasonId
        AND l.gameType2 = agg_batting_stats.gameType2
    )
WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
AND aggregationType = 'AGGREGATED'
AND EXISTS (
  SELECT 1 FROM agg_batting_stats l
  WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
    AND l.aggregationType = 'AGGREGATED'
    AND l.gameType2 = 'RS'
    AND l.majorLeagueId = agg_batting_stats.majorLeagueId
    AND l.seasonId = agg_batting_stats.seasonId
    AND l.gameType2 = agg_batting_stats.gameType2
);


UPDATE agg_batting_stats
    SET onBasePlusSluggingPercentagePlus = onBasePercentage * 1.0 / leagueOnBasePercentage + sluggingPercentage * 1.0 / leagueSluggingPercentage - 1
WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
AND   aggregationType = 'AGGREGATED';
