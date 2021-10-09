USE baseball;

DROP PROCEDURE woba;

DELIMITER //

CREATE PROCEDURE woba( )
BEGIN

/* Actualizar valores de los pesos en la tabla */
UPDATE
  agg_batting_stats abs
INNER JOIN (
  SELECT
    majorLeagueId,
    seasonId,
    SUM(IF(event = 'Walk', runValue, 0)) weightUnintentionalWalk,
    SUM(IF(event = 'Hit By Pitch', runValue, 0)) weightHitByPitch,
    SUM(IF(event = 'Single', runValue, 0)) weightSingle,
    SUM(IF(event = 'Double', runValue, 0)) weightDouble,
    SUM(IF(event = 'Triple', runValue, 0)) weightTriple,
    SUM(IF(event = 'Home Run', runValue, 0)) weightHomeRun,
    SUM(IF(event = 'Out', runValue, 0)) weightOut
  FROM rem_event_run_value
  WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID'
  GROUP BY
    1, 2
) w
  ON abs.majorLeagueId = w.majorLeagueId
  AND abs.seasonId = w.seasonId
  SET abs.weightUnintentionalWalk = w.weightUnintentionalWalk
  ,   abs.weightHitByPitch = w.weightHitByPitch
  ,   abs.weightSingle = w.weightSingle
  ,   abs.weightDouble = w.weightDouble
  ,   abs.weightTriple = w.weightTriple
  ,   abs.weightHomeRun = w.weightHomeRun
  ,   abs.weightOut = w.weightOut
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND   aggregationType = 'AGGREGATED';

/* Calcular wOBA */
UPDATE
  agg_batting_stats
  SET weightedOnBaseAverage = IF(
                              atBats + unintentionalWalks + sacFlies + hitByPitch > 0,
                              (
                                unintentionalWalks * weightUnintentionalWalk +
								                hitByPitch * weightHitByPitch +
                                singles * weightSingle +
                                doubles * weightDouble +
                                triples * weightTriple +
                                homeRuns * weightHomeRun
                              ) / (atBats + unintentionalWalks + sacFlies + hitByPitch),
                              NULL
                            ),
  weightedOnBaseAverageRelativeToOuts = IF(
                              atBats + unintentionalWalks + sacFlies + hitByPitch > 0,
                              (
                                unintentionalWalks * ( weightUnintentionalWalk + ABS(weightOut) ) +
								                hitByPitch * ( weightHitByPitch + ABS(weightOut) ) +
                                singles * ( weightSingle + ABS(weightOut) ) +
                                doubles * ( weightDouble + ABS(weightOut) ) +
                                triples * ( weightTriple + ABS(weightOut) ) +
                                homeRuns * ( weightHomeRun + ABS(weightOut) )
                              ) / (atBats + unintentionalWalks + sacFlies + hitByPitch),
                              NULL
                            )
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND   aggregationType = 'AGGREGATED';

COMMIT;

END //

DELIMITER ;
