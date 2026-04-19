USE baseball;

DROP PROCEDURE agg_pitching_derived_metrics;

DELIMITER //

CREATE PROCEDURE agg_pitching_derived_metrics( )
BEGIN

UPDATE
  agg_pitching_stats
  SET
    totalBases = singles + doubles*2 + triples*3 + homeRuns*4;

UPDATE
  agg_pitching_stats
  SET
    strikeOutsPerNineInnings = IF(outs > 0, strikeouts * 27 / outs, NULL)
  , walksPerNineInnings = IF(outs > 0, walks * 27 / outs, NULL)
  , homeRunsPerNineInnings = IF(outs > 0, homeRuns * 27 / outs, NULL)
  , runsPerNineInnings = IF(outs > 0, runs * 27 / outs, NULL)
  , earnedRunsPerNineInnings = IF(outs > 0, earnedRuns * 27 / outs, NULL)
  , walksHitsPerInning = IF(outs > 0, (hits + walks) * 3 / outs, NULL)
  , strikeOutPerBattersFaced = IF(battersFaced > 0, strikeOuts / battersFaced, NULL)
  , baseOnBallsPerBattersFaced = IF(battersFaced > 0, walks / battersFaced, NULL)
  , strikeOutsWalksPercentage = IF(battersFaced > 0, (strikeOuts - walks) / battersFaced, NULL)
  , strikeOutsPerWalksPercentage = IF(walks > 0, strikeOuts / walks, NULL)
  , leftOnBasePercentage = IF(hits + walks + hitBatsmen - 1.4 * homeRuns > 0, (hits + walks + hitBatsmen - runs) / (hits + walks + hitBatsmen - 1.4 * homeRuns), NULL)
  , opponentsBattingAverage = IF(atbats > 0, hits / atBats, NULL)
  , battedBallsInPlayPercentage = IF(atBats - strikeOuts - homeRuns - sacFlies > 0, (singles + doubles + triples) / (atBats - strikeOuts - homeRuns - sacFlies), NULL)
  , sluggingPercentage = IF(atBats > 0, totalBases / atBats, NULL)
  , stolenBasePercentage = IF(caughtStealing + stolenBases > 0, stolenBases / (caughtStealing + stolenBases), NULL)
  , onBasePercentage = IF(plateAppearances > 0, (hits + walks + hitBatsmen) / plateAppearances, NULL)
  , onBasePlusSluggingPercentage = IF(plateAppearances > 0, (hits + walks + hitBatsmen) / plateAppearances, 0) + IF(atbats > 0, totalBases / atBats, 0)
  , isolatedPower = IF(atBats > 0, (doubles + 2 * triples + 3 * homeRuns) / atBats, NULL)
  , savePercentage = IF(saveOpportunities > 0, saves / saveOpportunities, NULL)
  , winPercentage = IF (wins + losses > 0, wins / (wins + losses), NULL)
  , inningsPitched = outs DIV 3 + .1 * MOD( outs, 3)
  ;

COMMIT;

END //

DELIMITER ;
