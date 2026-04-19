-- Procedure: woba

/* Actualizar valores de los pesos en la tabla */
UPDATE agg_batting_stats
SET weightUnintentionalWalk = (SELECT SUM(CASE WHEN event = 'Walk' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId),
    weightHitByPitch = (SELECT SUM(CASE WHEN event = 'Hit By Pitch' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId),
    weightSingle = (SELECT SUM(CASE WHEN event = 'Single' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId),
    weightDouble = (SELECT SUM(CASE WHEN event = 'Double' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId),
    weightTriple = (SELECT SUM(CASE WHEN event = 'Triple' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId),
    weightHomeRun = (SELECT SUM(CASE WHEN event = 'Home Run' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId),
    weightOut = (SELECT SUM(CASE WHEN event = 'Out' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId)
WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                               'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                             )
AND   aggregationType = 'AGGREGATED'
AND   EXISTS (SELECT 1 FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID' AND rem_event_run_value.majorLeagueId = agg_batting_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_batting_stats.seasonId);

/* Calcular wOBA */
UPDATE
  agg_batting_stats
  SET weightedOnBaseAverage = CASE WHEN
                              atBats + unintentionalWalks + sacFlies + hitByPitch > 0
                              THEN
                              (
                                unintentionalWalks * weightUnintentionalWalk +
                                hitByPitch * weightHitByPitch +
                                singles * weightSingle +
                                doubles * weightDouble +
                                triples * weightTriple +
                                homeRuns * weightHomeRun
                              ) * 1.0 / (atBats + unintentionalWalks + sacFlies + hitByPitch)
                              ELSE NULL
                            END,
  weightedOnBaseAverageRelativeToOuts = CASE WHEN
                              atBats + unintentionalWalks + sacFlies + hitByPitch > 0
                              THEN
                              (
                                unintentionalWalks * ( weightUnintentionalWalk + ABS(weightOut) ) +
                                hitByPitch * ( weightHitByPitch + ABS(weightOut) ) +
                                singles * ( weightSingle + ABS(weightOut) ) +
                                doubles * ( weightDouble + ABS(weightOut) ) +
                                triples * ( weightTriple + ABS(weightOut) ) +
                                homeRuns * ( weightHomeRun + ABS(weightOut) )
                              ) * 1.0 / (atBats + unintentionalWalks + sacFlies + hitByPitch)
                              ELSE NULL
                            END
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND   aggregationType = 'AGGREGATED';
