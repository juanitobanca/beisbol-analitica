-- Procedure: agg_batting_derived_metrics

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
    singlesPercentage = ROUND(CASE WHEN hits > 0 THEN singles * 1.0 / hits ELSE NULL END, 3 )
  , doublesPercentage = ROUND(CASE WHEN hits > 0 THEN doubles * 1.0 / hits ELSE NULL END, 3 )
  , triplesPercentage = ROUND(CASE WHEN hits > 0 THEN triples * 1.0 / hits ELSE NULL END, 3 )
  , homeRunsPercentage = ROUND(CASE WHEN hits > 0 THEN homeRuns * 1.0 / hits ELSE NULL END, 3 )
  , strikeOutsPercentage = ROUND(CASE WHEN atbats > 0 THEN strikeOuts * 1.0 / plateAppearances ELSE NULL END, 3 )
  , walksPercentage = ROUND(CASE WHEN atbats > 0 THEN (unintentionalWalks + intentionalWalks ) * 1.0 / plateAppearances ELSE NULL END, 3 )
  , hitsPercentage = ROUND(CASE WHEN atbats > 0 THEN hits * 1.0 / plateAppearances ELSE NULL END, 3 )
  , battingAverageOnBallsInPlay = ROUND(CASE WHEN atBats - strikeOuts - homeRuns + sacFlies > 0 THEN (singles + doubles + triples) * 1.0 / (atBats - strikeOuts - homeRuns + sacFlies) ELSE NULL END, 3 )
  , battingAverage = ROUND(CASE WHEN atBats > 0 THEN hits * 1.0 / atBats ELSE NULL END, 3 )
  , onBasePercentage = ROUND(CASE WHEN plateAppearances > 0 THEN (hits + walks + hitByPitch) * 1.0 / plateAppearances ELSE NULL END, 3 )
  , extraBasePercentage = ROUND(CASE WHEN atbats > 0 THEN (doubles + triples + homeRuns) * 1.0 / atbats ELSE NULL END, 3 )
  , onFirstBasePercentage = ROUND(CASE WHEN plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch  > 0 THEN (singles + unintentionalWalks) * 1.0 / (plateAppearances - sacFlies - sacBunts - intentionalWalks - hitByPitch) ELSE NULL END, 3 )
  , homeRunPercentage = ROUND(CASE WHEN atbats  > 0 THEN homeRuns * 1.0 / atbats ELSE NULL END, 3 )
  , atBatsPerHomeRunsPercentage = ROUND(CASE WHEN homeRuns > 0 THEN atBats * 1.0 / homeRuns ELSE NULL END, 3 )
  , extraBaseHitPercentage = ROUND(CASE WHEN hits > 0 THEN (doubles + triples + homeRuns) * 1.0 / hits ELSE NULL END, 3 )
  , inPlayPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN (atBats - strikeOuts - homeRuns) * 1.0 / plateAppearances ELSE NULL END, 3 )
  , homeRunsPerPlateAppearancesPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN homeRuns * 1.0 / plateAppearances ELSE NULL END, 3 )
  , isolatedPower = ROUND(CASE WHEN atBats > 0 THEN (doubles + 2 * triples + 3 * homeRuns) * 1.0 / atBats ELSE NULL END, 3 )
  , onBasePlusSluggingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN (hits + walks + hitByPitch) * 1.0 / plateAppearances ELSE 0 END + CASE WHEN atBats > 0 THEN totalBases * 1.0 / atBats ELSE 0 END,3)
  , powerSpeed = ROUND(CASE WHEN homeRuns + stolenBases > 0 THEN 2.0 * homeRuns * stolenBases / (homeRuns + stolenBases) ELSE NULL END, 3 )
  , runsCreated = ROUND(CASE WHEN walks + atBats > 0 THEN (singles + doubles + triples + homeRuns + walks) * 1.0 * totalBases / (atBats + walks) ELSE NULL END, 3 )
  , runScoredPercentage = ROUND(CASE WHEN singles + doubles + triples + homeRuns + walks + hitByPitch - homeRuns > 0 THEN (runs - homeRuns) * 1.0 / (singles + doubles + triples + homeRuns + walks + hitByPitch - homeRuns) ELSE NULL END, 3 )
  , secondBattingAverage = ROUND(CASE WHEN atBats > 0 THEN (walks + doubles + 2 * triples + 3 * homeRuns + stolenBases - caughtStealing) * 1.0 / atBats ELSE NULL END, 3 )
  , sluggingPercentage = ROUND(CASE WHEN atBats > 0 THEN totalBases * 1.0 / atBats ELSE NULL END, 3 )
  , stolenBasePercentage = ROUND(CASE WHEN stolenBaseAttempts > 0 THEN stolenBases * 1.0 / stolenBaseAttempts ELSE NULL END, 3 )
  , strikeOutsPerPlateAppearancesPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN strikeOuts * 1.0 / plateAppearances ELSE NULL END, 3 )
  , walksPerPlateAppearancesPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN walks * 1.0 / plateAppearances ELSE NULL END, 3 )
  , walksPerStrikeOutsPercentage = ROUND(CASE WHEN strikeOuts > 0 THEN walks * 1.0 / strikeOuts ELSE NULL END, 3 )
  , strikeOutsOverBaseOnBallsPercentage = CASE WHEN walks > 0 THEN strikeOuts * 1.0 / walks ELSE NULL END
  ;

UPDATE
  agg_batting_stats
  SET zeroAndZeroSwingPercentage =ROUND(CASE WHEN plateAppearances > 0 THEN swingsZeroAndZero * 1.0 / plateAppearances ELSE NULL END, 3 ),
      zeroAndOneSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsZeroAndOne * 1.0 / plateAppearances ELSE NULL END, 3 ),
      zeroAndTwoSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsZeroAndTwo * 1.0 / plateAppearances ELSE NULL END, 3 ),
      -- 1 Ball(s)
      oneAndZeroSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsOneAndZero * 1.0 / plateAppearances ELSE NULL END, 3 ),
      oneAndOneSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsOneAndOne * 1.0 / plateAppearances ELSE NULL END, 3 ),
      oneAndTwoSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsOneAndTwo * 1.0 / plateAppearances ELSE NULL END, 3 ),
      -- 2 Ball(s)
      twoAndZeroSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsTwoAndZero * 1.0 / plateAppearances ELSE NULL END, 3 ),
      twoAndOneSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsTwoAndOne * 1.0 / plateAppearances ELSE NULL END, 3 ),
      twoAndTwoSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsTwoAndTwo * 1.0 / plateAppearances ELSE NULL END, 3 ),
      -- 3 Ball(s)
      threeAndZeroSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsThreeAndZero * 1.0 / plateAppearances ELSE NULL END, 3 ),
      threeAndOneSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsThreeAndOne * 1.0 / plateAppearances ELSE NULL END, 3 ),
      threeAndTwoSwingPercentage = ROUND(CASE WHEN plateAppearances > 0 THEN swingsThreeAndTwo * 1.0 / plateAppearances ELSE NULL END, 3 );
