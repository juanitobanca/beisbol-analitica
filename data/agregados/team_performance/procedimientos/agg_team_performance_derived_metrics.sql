USE baseball;

DROP PROCEDURE agg_team_performance_stats_derived_metrics;

DELIMITER //

CREATE PROCEDURE agg_team_performance_stats_derived_metrics( )
BEGIN


UPDATE
  agg_team_performance_stats
  SET
    runDifferential = runs - runsAllowed,
    winPercentage = IF( wins + losses > 0, ( wins ) / ( wins + losses ), NULL ),
    -- https://beisbolanalitica.com/2019/12/21/simplificacion/
    pythagoreanExpectation =IF( runsAllowed > 0, ( runs * runs ) / ( runsAllowed * runsAllowed), NULL ) ;

  COMMIT;

END //

DELIMITER ;
