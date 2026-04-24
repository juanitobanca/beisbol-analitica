-- Procedure: agg_fielding_derived_metrics

UPDATE
  agg_fielding_stats
  SET
    inningsPlayed = outsPlayed * 1.0 / 3,
    gamesPlayed = outsPlayed * 1.0 / 27;

UPDATE
  agg_fielding_stats
  SET
    fieldingPercentage = CASE WHEN putOuts + assists + errors > 0 THEN ( putouts + assists ) * 1.0 / ( putOuts + assists + errors ) ELSE NULL END
  , rangeFactorPerInning =  ( putOuts + assists ) * 1.0 / inningsPlayed
  , rangeFactorPerGame = ( putOuts + assists ) * 1.0 / gamesPlayed;
