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
    singlesPercentage = ROUND(IF( hits > 0, singles / hits, NULL), 3 )
  , doublesPercentage = ROUND(IF( hits > 0, doubles / hits, NULL), 3 )
  , triplesPercentage = ROUND(IF( hits > 0, triples / hits, NULL), 3 )
  , homeRunsPercentage = ROUND(IF( hits > 0, homeRuns / hits, NULL), 3 )
  , strikeOutsPercentage = ROUND(IF( atbats > 0, strikeOuts / plateAppearances, NULL), 3 )
  , walksPercentage = ROUND(IF( atbats > 0, (unintentionalWalks + intentionalWalks ) / plateAppearances, NULL), 3 )
  , hitsPercentage = ROUND(IF( atbats > 0, hits  / plateAppearances, NULL), 3 )
  , battingAverageOnBallsInPlay = ROUND(IF(atBats - strikeOuts - homeRuns + sacFlies > 0,(singles + doubles + triples) / (atBats - strikeOuts - homeRuns + sacFlies), NULL), 3 )
  , battingAverage = ROUND(IF(atBats > 0, hits / atBats, NULL), 3 )
  , onBasePercentage = ROUND(IF(plateAppearances > 0, (hits + walks + hitByPitch) / plateAppearances, NULL), 3 )
  , extraBasePercentage = ROUND(IF(atbats > 0, (doubles + triples + homeRuns) / atbats, NULL), 3 )
  , onFirstBasePercentage = ROUND(IF(plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch  > 0, (singles + unintentionalWalks) / (plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch), NULL), 3 )
  , homeRunPercentage = ROUND(IF(atbats  > 0, homeRuns / atbats, NULL), 3 )
  , atBatsPerHomeRunsPercentage = ROUND(IF(homeRuns > 0, atBats / homeRuns, NULL), 3 )
  , extraBaseHitPercentage = ROUND(IF(hits > 0, (doubles + triples + homeRuns) / hits, NULL), 3 )
  , inPlayPercentage = ROUND(IF(plateAppearances > 0, (atBats - strikeOuts - homeRuns) / plateAppearances, NULL), 3 )
  , homeRunsPerPlateAppearancesPercentage = ROUND(IF(plateAppearances > 0, homeRuns / plateAppearances, NULL), 3 )
  , isolatedPower = ROUND(IF(atBats > 0, (doubles + 2 * triples + 3 * homeRuns) / atBats, NULL), 3 )
  , onBasePlusSluggingPercentage = ROUND(IF(plateAppearances > 0, (hits + walks + hitByPitch) / plateAppearances, 0 ) + IF(atBats > 0, totalBases / atBats, 0),3)
  , powerSpeed = ROUND(IF(homeRuns + stolenBases > 0, 2 * homeRuns * stolenBases / (homeRuns + stolenBases), NULL), 3 )
  , runsCreated = ROUND(IF(walks + atBats > 0, (singles + doubles + triples + homeRuns + walks) * totalBases / (atBats + walks), NULL), 3 )
  , runScoredPercentage = ROUND(IF(singles + doubles + triples + homeRuns + walks + hitByPitch - homeRuns > 0, (runs - homeRuns) / (singles + doubles + triples + homeRuns + walks + hitByPitch - homeRuns), NULL), 3 )
  , secondBattingAverage = ROUND(IF(atBats > 0, (walks + doubles + 2 * triples + 3 * homeRuns + stolenBases - caughtStealing) / atBats, NULL), 3 )
  , sluggingPercentage = ROUND(IF(atBats > 0, totalBases / atBats, NULL), 3 )
  , stolenBasePercentage = ROUND(IF(stolenBaseAttempts > 0, stolenBases / stolenBaseAttempts, NULL), 3 )
  , strikeOutsPerPlateAppearancesPercentage = ROUND(IF(plateAppearances > 0, strikeOuts / plateAppearances, NULL), 3 )
  , walksPerPlateAppearancesPercentage = ROUND(IF(plateAppearances > 0, walks / plateAppearances, NULL), 3 )
  , walksPerStrikeOutsPercentage = ROUND(IF(strikeOuts > 0, walks / strikeOuts, NULL), 3 )
  , strikeOutsOverBaseOnBallsPercentage = IF(walks > 0, strikeOuts / walks, NULL)
  ;

UPDATE
  agg_batting_stats
  SET zeroAndZeroSwingPercentage =ROUND(IF( plateAppearances > 0, swingsZeroAndZero / plateAppearances, NULL), 3 ),
      zeroAndOneSwingPercentage = ROUND(IF( plateAppearances > 0, swingsZeroAndOne  / plateAppearances, NULL), 3 ),
      zeroAndTwoSwingPercentage = ROUND(IF( plateAppearances > 0, swingsZeroAndTwo  / plateAppearances, NULL), 3 ),
      -- 1 Ball(s)
      oneAndZeroSwingPercentage = ROUND(IF( plateAppearances > 0, swingsOneAndZero  / plateAppearances, NULL), 3 ),
      oneAndOneSwingPercentage = ROUND(IF( plateAppearances > 0, swingsOneAndOne  / plateAppearances, NULL), 3 ),
      oneAndTwoSwingPercentage = ROUND(IF( plateAppearances > 0, swingsOneAndTwo  / plateAppearances, NULL), 3 ),
      -- 2 Ball(s)
      twoAndZeroSwingPercentage = ROUND(IF( plateAppearances > 0, swingsTwoAndZero  / plateAppearances, NULL), 3 ),
      twoAndOneSwingPercentage = ROUND(IF( plateAppearances > 0, swingsTwoAndOne  / plateAppearances, NULL), 3 ),
      twoAndTwoSwingPercentage = ROUND(IF( plateAppearances > 0, swingsTwoAndTwo  / plateAppearances, NULL), 3 ),
      -- 3 Ball(s)
      threeAndZeroSwingPercentage = ROUND(IF( plateAppearances > 0, swingsThreeAndZero  / plateAppearances, NULL), 3 ),
      threeAndOneSwingPercentage = ROUND(IF( plateAppearances > 0, swingsThreeAndOne  / plateAppearances, NULL), 3 ),
      threeAndTwoSwingPercentage = ROUND(IF( plateAppearances > 0, swingsThreeAndTwo  / plateAppearances, NULL), 3 );

  COMMIT;

END //

DELIMITER ;
