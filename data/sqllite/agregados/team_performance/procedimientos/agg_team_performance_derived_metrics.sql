-- Procedure: agg_team_performance_stats_derived_metrics

UPDATE
  agg_team_performance_stats
  SET
    runDifferential = runs - runsAllowed,
    winPercentage = CASE WHEN wins + losses > 0 THEN ( wins ) * 1.0 / ( wins + losses ) ELSE NULL END,
    -- https://beisbolanalitica.com/2019/12/21/simplificacion/
    pythagoreanExpectation = CASE WHEN runsAllowed > 0 THEN ( runs * runs ) * 1.0 / ( runsAllowed * runsAllowed) ELSE NULL END;
