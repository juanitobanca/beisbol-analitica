-- Procedure: agg_pitching_derived_metrics

UPDATE
  agg_pitching_stats
  SET
    totalBases = singles + doubles*2 + triples*3 + homeRuns*4;

UPDATE
  agg_pitching_stats
  SET
    strikeOutsPerNineInnings = CASE WHEN outs > 0 THEN strikeouts * 27.0 / outs ELSE NULL END
  , walksPerNineInnings = CASE WHEN outs > 0 THEN walks * 27.0 / outs ELSE NULL END
  , homeRunsPerNineInnings = CASE WHEN outs > 0 THEN homeRuns * 27.0 / outs ELSE NULL END
  , runsPerNineInnings = CASE WHEN outs > 0 THEN runs * 27.0 / outs ELSE NULL END
  , earnedRunsPerNineInnings = CASE WHEN outs > 0 THEN earnedRuns * 27.0 / outs ELSE NULL END
  , walksHitsPerInning = CASE WHEN outs > 0 THEN (hits + walks) * 3.0 / outs ELSE NULL END
  , strikeOutPerBattersFaced = CASE WHEN battersFaced > 0 THEN strikeOuts * 1.0 / battersFaced ELSE NULL END
  , baseOnBallsPerBattersFaced = CASE WHEN battersFaced > 0 THEN walks * 1.0 / battersFaced ELSE NULL END
  , strikeOutsWalksPercentage = CASE WHEN battersFaced > 0 THEN (strikeOuts - walks) * 1.0 / battersFaced ELSE NULL END
  , strikeOutsPerWalksPercentage = CASE WHEN walks > 0 THEN strikeOuts * 1.0 / walks ELSE NULL END
  , leftOnBasePercentage = CASE WHEN hits + walks + hitBatsmen - 1.4 * homeRuns > 0 THEN (hits + walks + hitBatsmen - runs) * 1.0 / (hits + walks + hitBatsmen - 1.4 * homeRuns) ELSE NULL END
  , opponentsBattingAverage = CASE WHEN atbats > 0 THEN hits * 1.0 / atBats ELSE NULL END
  , battedBallsInPlayPercentage = CASE WHEN atBats - strikeOuts - homeRuns - sacFlies > 0 THEN (singles + doubles + triples) * 1.0 / (atBats - strikeOuts - homeRuns - sacFlies) ELSE NULL END
  , sluggingPercentage = CASE WHEN atBats > 0 THEN totalBases * 1.0 / atBats ELSE NULL END
  , stolenBasePercentage = CASE WHEN caughtStealing + stolenBases > 0 THEN stolenBases * 1.0 / (caughtStealing + stolenBases) ELSE NULL END
  , onBasePercentage = CASE WHEN plateAppearances > 0 THEN (hits + walks + hitBatsmen) * 1.0 / plateAppearances ELSE NULL END
  , onBasePlusSluggingPercentage = CASE WHEN plateAppearances > 0 THEN (hits + walks + hitBatsmen) * 1.0 / plateAppearances ELSE 0 END + CASE WHEN atbats > 0 THEN totalBases * 1.0 / atBats ELSE 0 END
  , isolatedPower = CASE WHEN atBats > 0 THEN (doubles + 2 * triples + 3 * homeRuns) * 1.0 / atBats ELSE NULL END
  , savePercentage = CASE WHEN saveOpportunities > 0 THEN saves * 1.0 / saveOpportunities ELSE NULL END
  , winPercentage = CASE WHEN wins + losses > 0 THEN wins * 1.0 / (wins + losses) ELSE NULL END
  , inningsPitched = outs / 3 + .1 * ( outs % 3)
  ;
