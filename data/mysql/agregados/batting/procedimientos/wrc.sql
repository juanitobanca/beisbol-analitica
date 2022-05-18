USE baseball;

DROP PROCEDURE wrc;

DELIMITER //

CREATE PROCEDURE wrc( )
BEGIN

UPDATE
  agg_batting_stats abs
INNER JOIN (
  SELECT
    majorLeagueId,
    seasonId,
    runs AS leagueRuns,
    atBats + unintentionalWalks + sacFlies + hitByPitch AS leaguePlateAppearances
  FROM agg_batting_stats
  WHERE
    groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
    AND gameType2 = 'RS'
    AND aggregationType = 'AGGREGATED'
) w
  ON abs.majorLeagueId = w.majorLeagueId
  AND abs.seasonId = w.seasonId
  SET abs.leagueRuns = w.leagueRuns
  ,   abs.leaguePlateAppearances = w.leaguePlateAppearances
  WHERE groupingDescription IN ( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

UPDATE
  agg_batting_stats
  SET weightedRunsCreated =  ( ( weightedOnBaseAverageRelativeToOuts - leagueWeightedOnBaseAverageRelativeToOuts ) / weightedOnBaseAverageScale + leagueRuns / leaguePlateAppearances ) * ( atBats + unintentionalWalks + sacFlies + hitByPitch )
  WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
  AND aggregationType = 'AGGREGATED';

COMMIT;

END //

DELIMITER ;
