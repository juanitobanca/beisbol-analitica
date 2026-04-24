-- Procedure: wrc

UPDATE agg_batting_stats
SET leagueRuns = (
      SELECT runs
      FROM agg_batting_stats w
      WHERE w.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND w.gameType2 = 'RS'
        AND w.aggregationType = 'AGGREGATED'
        AND w.majorLeagueId = agg_batting_stats.majorLeagueId
        AND w.seasonId = agg_batting_stats.seasonId
    ),
    leaguePlateAppearances = (
      SELECT atBats + unintentionalWalks + sacFlies + hitByPitch
      FROM agg_batting_stats w
      WHERE w.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND w.gameType2 = 'RS'
        AND w.aggregationType = 'AGGREGATED'
        AND w.majorLeagueId = agg_batting_stats.majorLeagueId
        AND w.seasonId = agg_batting_stats.seasonId
    )
WHERE groupingDescription IN ( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                             )
AND aggregationType = 'AGGREGATED'
AND EXISTS (
  SELECT 1 FROM agg_batting_stats w
  WHERE w.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
    AND w.gameType2 = 'RS'
    AND w.aggregationType = 'AGGREGATED'
    AND w.majorLeagueId = agg_batting_stats.majorLeagueId
    AND w.seasonId = agg_batting_stats.seasonId
);

UPDATE
  agg_batting_stats
  SET weightedRunsCreated =  ( ( weightedOnBaseAverageRelativeToOuts - leagueWeightedOnBaseAverageRelativeToOuts ) / weightedOnBaseAverageScale + leagueRuns * 1.0 / leaguePlateAppearances ) * ( atBats + unintentionalWalks + sacFlies + hitByPitch )
  WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
  AND aggregationType = 'AGGREGATED';
