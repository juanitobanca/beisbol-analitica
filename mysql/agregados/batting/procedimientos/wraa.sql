USE baseball;

DROP PROCEDURE wraa;

DELIMITER //

CREATE PROCEDURE wraa( )
BEGIN

UPDATE
  agg_batting_stats abs
INNER JOIN (
  SELECT
    majorLeagueId,
    seasonId,
    onBasePercentage / weightedOnBaseAverageRelativeToOuts AS weightedOnBaseAverageScale,
    weightedOnBaseAverageRelativeToOuts AS leagueWeightedOnBaseAverageRelativeToOuts
  FROM agg_batting_stats
  WHERE
    groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
    AND gameType2 = 'RS'
    AND aggregationType = 'AGGREGATED'
) w
  ON abs.majorLeagueId = w.majorLeagueId
  AND abs.seasonId = w.seasonId
  SET abs.weightedOnBaseAverageScale = w.weightedOnBaseAverageScale
  ,   abs.leagueWeightedOnBaseAverageRelativeToOuts = w.leagueWeightedOnBaseAverageRelativeToOuts
  WHERE groupingDescription IN ( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

UPDATE
  agg_batting_stats
  SET weightedRunsAboveAverage = ( weightedOnBaseAverageRelativeToOuts - leagueWeightedOnBaseAverageRelativeToOuts ) / weightedOnBaseAverageScale * ( atBats + unintentionalWalks + sacFlies + hitByPitch )
  WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
  AND aggregationType = 'AGGREGATED';

COMMIT;

END //

DELIMITER ;
