USE baseball;

DROP PROCEDURE agg_batting_derived_metrics;

DELIMITER //

CREATE PROCEDURE agg_batting_derived_metrics( )
BEGIN


UPDATE
  agg_batting_stats
  SET
    plateAppearances = atBats + sacBunts + sacFlies + walks + hitByPitch
  , singles = hits - homeRuns - doubles - triples
  , stolenBaseAttempts = caughtStealing + stolenBases
  , unintentionalWalks = walks - intentionalWalks;

UPDATE
  agg_batting_stats
  SET
    totalBases = singles + doubles*2 + triples*3 + homeRuns*4;

UPDATE
  agg_batting_stats
  SET
    -- dash percentages
    atBatsPerHomeRunsPercentage = IF(homeRuns > 0, atBats / homeRuns, NULL)
  , battingAverageOnBallsInPlay = IF(atBats - strikeOuts - homeRuns + sacFlies > 0,(singles + doubles + triples) / (atBats - strikeOuts - homeRuns + sacFlies), NULL)
  , battingAverage = IF(atBats > 0, hits / atBats, NULL)
  , onBasePercentage = IF(plateAppearances > 0, (hits + walks + hitByPitch) / plateAppearances, NULL)
  , extraBasePercentage = IF(plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch > 0, (doubles + triples + homeRuns) / (plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch), NULL)
  , onFirstBasePercentage = IF(plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch  > 0, (singles + unintentionalWalks) / (plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch), NULL)
  , strikeOutsOverBaseOnBallsPercentage = IF( strikeOuts + unintentionalWalks > 0, strikeOuts / ( strikeOuts + unintentionalWalks ), NULL)
  , homeRunPercentage = IF(plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch  > 0, (homeRuns) / (plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch ), NULL)

  , extraBaseHitPercentage = IF(hits > 0, (doubles + triples + homeRuns) / hits, NULL)
  , inPlayPercentage = IF(plateAppearances > 0, (atBats - strikeOuts - homeRuns) / plateAppearances, NULL)
  , homeRunsPerPlateAppearancesPercentage = IF(plateAppearances > 0, homeRuns / plateAppearances, NULL)
  , isolatedPower = IF(atBats > 0, (doubles + 2 * triples + 3 * homeRuns) / atBats, NULL)
  , onBasePlusSluggingPercentage = IF(plateAppearances > 0, (hits + walks + hitByPitch) / plateAppearances, 0 ) + IF(atBats > 0, totalBases / atBats, 0)
  , powerSpeed = IF(homeRuns + stolenBases > 0, 2 * homeRuns * stolenBases / (homeRuns + stolenBases), NULL)
  , runsCreated = IF(walks + atBats > 0, (singles + doubles + triples + homeRuns + walks) * totalBases / (atBats + walks), NULL)
  , runScoredPercentage = IF(singles + doubles + triples + homeRuns + walks + hitByPitch - homeRuns > 0, (runs - homeRuns) / (singles + doubles + triples + homeRuns + walks + hitByPitch - homeRuns), NULL)
  , secondBattingAverage = IF(atBats > 0, (walks + doubles + 2 * triples + 3 * homeRuns + stolenBases - caughtStealing) / atBats, NULL)
  , sluggingPercentage = IF(atBats > 0, totalBases / atBats, NULL)
  , stolenBasePercentage = IF(stolenBaseAttempts > 0, stolenBases / stolenBaseAttempts, NULL)
  , strikeOutsPerPlateAppearancesPercentage = IF(plateAppearances > 0, strikeOuts / plateAppearances, NULL)
  , walksPerPlateAppearancesPercentage = IF(plateAppearances > 0, walks / plateAppearances, NULL)
  , walksPerStrikeOutsPercentage = IF(strikeOuts > 0, walks / strikeOuts, NULL);

UPDATE
  agg_batting_stats
  SET zeroAndZeroSwingPercentage =IF( plateAppearances > 0, swingsZeroAndZero / plateAppearances, NULL ),
      zeroAndOneSwingPercentage = IF( plateAppearances > 0, swingsZeroAndOne  / plateAppearances, NULL ),
      zeroAndTwoSwingPercentage = IF( plateAppearances > 0, swingsZeroAndTwo  / plateAppearances, NULL ),
      -- 1 Ball(s)
      oneAndZeroSwingPercentage = IF( plateAppearances > 0, swingsOneAndZero  / plateAppearances, NULL ),
      oneAndOneSwingPercentage = IF( plateAppearances > 0, swingsOneAndOne  / plateAppearances, NULL ),
      oneAndTwoSwingPercentage = IF( plateAppearances > 0, swingsOneAndTwo  / plateAppearances, NULL ),
      -- 2 Ball(s)
      twoAndZeroSwingPercentage = IF( plateAppearances > 0, swingsTwoAndZero  / plateAppearances, NULL ),
      twoAndOneSwingPercentage = IF( plateAppearances > 0, swingsTwoAndOne  / plateAppearances, NULL ),
      twoAndTwoSwingPercentage = IF( plateAppearances > 0, swingsTwoAndTwo  / plateAppearances, NULL ),
      -- 3 Ball(s)
      threeAndZeroSwingPercentage = IF( plateAppearances > 0, swingsThreeAndZero  / plateAppearances, NULL ),
      threeAndOneSwingPercentage = IF( plateAppearances > 0, swingsThreeAndOne  / plateAppearances, NULL ),
      threeAndTwoSwingPercentage = IF( plateAppearances > 0, swingsThreeAndTwo  / plateAppearances, NULL );

  COMMIT;

END //

DELIMITER ;
