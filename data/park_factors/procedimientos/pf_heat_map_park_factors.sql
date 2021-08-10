USE baseball;

DROP PROCEDURE pf_heat_map_park_factors;

DELIMITER //

CREATE PROCEDURE pf_heat_map_park_factors()
BEGIN

INSERT INTO pf_heat_map_park_factors(
    groupingId,
    groupingDescription,
    majorLeagueId,
    seasonId,
    venueId,
    teamId,
    homeGames,
    awayGames,
    -- HM4
  heatMapFourLeftFieldOneSinglesScoredHome,
  heatMapFourLeftFieldOneDoublesScoredHome,
  heatMapFourLeftFieldOneTriplesScoredHome,
  heatMapFourLeftFieldOneHomeRunsScoredHome,
  heatMapFourLeftFieldOneHitsScoredHome,
  heatMapFourLeftFieldTwoDoublesScoredHome,
  heatMapFourLeftFieldTwoTriplesScoredHome,
  heatMapFourLeftFieldTwoHomeRunsScoredHome,
  heatMapFourLeftFieldTwoHitsScoredHome,
  heatMapFourRightFieldOneSinglesScoredHome,
  heatMapFourRightFieldOneDoublesScoredHome,
  heatMapFourRightFieldOneTriplesScoredHome,
  heatMapFourRightFieldOneHomeRunsScoredHome,
  heatMapFourRightFieldOneHitsScoredHome,
  heatMapFourRightFieldSinglesScoredHome,
  heatMapFourRightFieldTwoDoublesScoredHome,
  heatMapFourRightFieldTwoTriplesScoredHome,
  heatMapFourRightFieldTwoHomeRunsScoredHome,
  heatMapFourRightFieldTwoHitsScoredHome,
  heatMapFourLeftFieldOneSinglesScoredAway,
  heatMapFourLeftFieldOneDoublesScoredAway,
  heatMapFourLeftFieldOneTriplesScoredAway,
  heatMapFourLeftFieldOneHomeRunsScoredAway,
  heatMapFourLeftFieldOneHitsScoredAway,
  heatMapFourLeftFieldTwoDoublesScoredAway,
  heatMapFourLeftFieldTwoTriplesScoredAway,
  heatMapFourLeftFieldTwoHomeRunsScoredAway,
  heatMapFourLeftFieldTwoHitsScoredAway,
  heatMapFourRightFieldOneSinglesScoredAway,
  heatMapFourRightFieldOneDoublesScoredAway,
  heatMapFourRightFieldOneTriplesScoredAway,
  heatMapFourRightFieldOneHomeRunsScoredAway,
  heatMapFourRightFieldOneHitsScoredAway,
  heatMapFourRightFieldSinglesScoredAway,
  heatMapFourRightFieldTwoDoublesScoredAway,
  heatMapFourRightFieldTwoTriplesScoredAway,
  heatMapFourRightFieldTwoHomeRunsScoredAway,
  heatMapFourRightFieldTwoHitsScoredAway,
  heatMapFourLeftFieldOneSinglesAllowedHome,
  heatMapFourLeftFieldOneDoublesAllowedHome,
  heatMapFourLeftFieldOneTriplesAllowedHome,
  heatMapFourLeftFieldOneHomeRunsAllowedHome,
  heatMapFourLeftFieldOneHitsAllowedHome,
  heatMapFourLeftFieldTwoDoublesAllowedHome,
  heatMapFourLeftFieldTwoTriplesAllowedHome,
  heatMapFourLeftFieldTwoHomeRunsAllowedHome,
  heatMapFourLeftFieldTwoHitsAllowedHome,
  heatMapFourRightFieldOneSinglesAllowedHome,
  heatMapFourRightFieldOneDoublesAllowedHome,
  heatMapFourRightFieldOneTriplesAllowedHome,
  heatMapFourRightFieldOneHomeRunsAllowedHome,
  heatMapFourRightFieldOneHitsAllowedHome,
  heatMapFourRightFieldSinglesAllowedHome,
  heatMapFourRightFieldTwoDoublesAllowedHome,
  heatMapFourRightFieldTwoTriplesAllowedHome,
  heatMapFourRightFieldTwoHomeRunsAllowedHome,
  heatMapFourRightFieldTwoHitsAllowedHome,
  heatMapFourLeftFieldOneSinglesAllowedAway,
  heatMapFourLeftFieldOneDoublesAllowedAway,
  heatMapFourLeftFieldOneTriplesAllowedAway,
  heatMapFourLeftFieldOneHomeRunsAllowedAway,
  heatMapFourLeftFieldOneHitsAllowedAway,
  heatMapFourLeftFieldTwoDoublesAllowedAway,
  heatMapFourLeftFieldTwoTriplesAllowedAway,
  heatMapFourLeftFieldTwoHomeRunsAllowedAway,
  heatMapFourLeftFieldTwoHitsAllowedAway,
  heatMapFourRightFieldOneSinglesAllowedAway,
  heatMapFourRightFieldOneDoublesAllowedAway,
  heatMapFourRightFieldOneTriplesAllowedAway,
  heatMapFourRightFieldOneHomeRunsAllowedAway,
  heatMapFourRightFieldOneHitsAllowedAway,
  heatMapFourRightFieldSinglesAllowedAway,
  heatMapFourRightFieldTwoDoublesAllowedAway,
  heatMapFourRightFieldTwoTriplesAllowedAway,
  heatMapFourRightFieldTwoHomeRunsAllowedAway,
  heatMapFourRightFieldTwoHitsAllowedAway,
  heatMapFourLeftFieldOneSinglesParkFactor,
  heatMapFourLeftFieldOneDoublesParkFactor,
  heatMapFourLeftFieldOneTriplesParkFactor,
  heatMapFourLeftFieldOneHomeRunsParkFactor,
  heatMapFourLeftFieldOneHitsParkFactor,
  heatMapFourLeftFieldTwoDoublesParkFactor,
  heatMapFourLeftFieldTwoTriplesParkFactor,
  heatMapFourLeftFieldTwoHomeRunsParkFactor,
  heatMapFourLeftFieldTwoHitsParkFactor,
  heatMapFourRightFieldOneSinglesParkFactor,
  heatMapFourRightFieldOneDoublesParkFactor,
  heatMapFourRightFieldOneTriplesParkFactor,
  heatMapFourRightFieldOneHomeRunsParkFactor,
  heatMapFourRightFieldOneHitsParkFactor,
  heatMapFourRightFieldSinglesParkFactor,
  heatMapFourRightFieldTwoDoublesParkFactor,
  heatMapFourRightFieldTwoTriplesParkFactor,
  heatMapFourRightFieldTwoHomeRunsParkFactor,
  heatMapFourRightFieldTwoHitsParkFactor
  )
  WITH home_scored AS (
    SELECT
      groupingId,
      groupingDescription,
      majorLeagueId,
      seasonId,
      venueId,
      teamId,
      -- HM4
      heatMapFourLeftFieldOneSingles AS heatMapFourLeftFieldOneSinglesScoredHome,
      heatMapFourLeftFieldOneDoubles AS heatMapFourLeftFieldOneDoublesScoredHome,
      heatMapFourLeftFieldOneTriples AS heatMapFourLeftFieldOneTriplesScoredHome,
      heatMapFourLeftFieldOneHomeRuns AS heatMapFourLeftFieldOneHomeRunsScoredHome,
      heatMapFourLeftFieldOneHits AS heatMapFourLeftFieldOneHitsScoredHome,
      heatMapFourLeftFieldTwoDoubles AS heatMapFourLeftFieldTwoDoublesScoredHome,
      heatMapFourLeftFieldTwoTriples AS heatMapFourLeftFieldTwoTriplesScoredHome,
      heatMapFourLeftFieldTwoHomeRuns AS heatMapFourLeftFieldTwoHomeRunsScoredHome,
      heatMapFourLeftFieldTwoHits AS heatMapFourLeftFieldTwoHitsScoredHome,
      heatMapFourRightFieldOneSingles AS heatMapFourRightFieldOneSinglesScoredHome,
      heatMapFourRightFieldOneDoubles AS heatMapFourRightFieldOneDoublesScoredHome,
      heatMapFourRightFieldOneTriples AS heatMapFourRightFieldOneTriplesScoredHome,
      heatMapFourRightFieldOneHomeRuns AS heatMapFourRightFieldOneHomeRunsScoredHome,
      heatMapFourRightFieldOneHits AS heatMapFourRightFieldOneHitsScoredHome,
      heatMapFourRightFieldSingles AS heatMapFourRightFieldSinglesScoredHome,
      heatMapFourRightFieldTwoDoubles AS heatMapFourRightFieldTwoDoublesScoredHome,
      heatMapFourRightFieldTwoTriples AS heatMapFourRightFieldTwoTriplesScoredHome,
      heatMapFourRightFieldTwoHomeRuns AS heatMapFourRightFieldTwoHomeRunsScoredHome,
      heatMapFourRightFieldTwoHits AS heatMapFourRightFieldTwoHitsScoredHome,
      -- games
      games AS homeGames
    FROM agg_batting_balls_in_play_heatmaps
    WHERE
      groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_VENUEID_TEAMID_TEAMTYPE'
      AND gameType2 = 'RS'
      AND teamType = 'home'
  ),
  away_scored AS (
    SELECT
      majorLeagueId,
      seasonId,
      venueId,
      teamId,
      -- HM4
      heatMapFourLeftFieldOneSingles AS heatMapFourLeftFieldOneSinglesScoredAway,
      heatMapFourLeftFieldOneDoubles AS heatMapFourLeftFieldOneDoublesScoredAway,
      heatMapFourLeftFieldOneTriples AS heatMapFourLeftFieldOneTriplesScoredAway,
      heatMapFourLeftFieldOneHomeRuns AS heatMapFourLeftFieldOneHomeRunsScoredAway,
      heatMapFourLeftFieldOneHits AS heatMapFourLeftFieldOneHitsScoredAway,
      heatMapFourLeftFieldTwoDoubles AS heatMapFourLeftFieldTwoDoublesScoredAway,
      heatMapFourLeftFieldTwoTriples AS heatMapFourLeftFieldTwoTriplesScoredAway,
      heatMapFourLeftFieldTwoHomeRuns AS heatMapFourLeftFieldTwoHomeRunsScoredAway,
      heatMapFourLeftFieldTwoHits AS heatMapFourLeftFieldTwoHitsScoredAway,
      heatMapFourRightFieldOneSingles AS heatMapFourRightFieldOneSinglesScoredAway,
      heatMapFourRightFieldOneDoubles AS heatMapFourRightFieldOneDoublesScoredAway,
      heatMapFourRightFieldOneTriples AS heatMapFourRightFieldOneTriplesScoredAway,
      heatMapFourRightFieldOneHomeRuns AS heatMapFourRightFieldOneHomeRunsScoredAway,
      heatMapFourRightFieldOneHits AS heatMapFourRightFieldOneHitsScoredAway,
      heatMapFourRightFieldSingles AS heatMapFourRightFieldSinglesScoredAway,
      heatMapFourRightFieldTwoDoubles AS heatMapFourRightFieldTwoDoublesScoredAway,
      heatMapFourRightFieldTwoTriples AS heatMapFourRightFieldTwoTriplesScoredAway,
      heatMapFourRightFieldTwoHomeRuns AS heatMapFourRightFieldTwoHomeRunsScoredAway,
      heatMapFourRightFieldTwoHits AS heatMapFourRightFieldTwoHitsScoredAway,
      -- games
      games AS awayGames
    FROM agg_batting_balls_in_play_heatmaps
    WHERE
      groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID_TEAMTYPE'
      AND gameType2 = 'RS'
      AND teamType = 'away'
  ),
  home_allowed AS (
    SELECT
      majorLeagueId,
      seasonId,
      venueId,
      teamId,
      -- HM4
      heatMapFourLeftFieldOneSingles AS heatMapFourLeftFieldOneSinglesAllowedHome,
      heatMapFourLeftFieldOneDoubles AS heatMapFourLeftFieldOneDoublesAllowedHome,
      heatMapFourLeftFieldOneTriples AS heatMapFourLeftFieldOneTriplesAllowedHome,
      heatMapFourLeftFieldOneHomeRuns AS heatMapFourLeftFieldOneHomeRunsAllowedHome,
      heatMapFourLeftFieldOneHits AS heatMapFourLeftFieldOneHitsAllowedHome,
      heatMapFourLeftFieldTwoDoubles AS heatMapFourLeftFieldTwoDoublesAllowedHome,
      heatMapFourLeftFieldTwoTriples AS heatMapFourLeftFieldTwoTriplesAllowedHome,
      heatMapFourLeftFieldTwoHomeRuns AS heatMapFourLeftFieldTwoHomeRunsAllowedHome,
      heatMapFourLeftFieldTwoHits AS heatMapFourLeftFieldTwoHitsAllowedHome,
      heatMapFourRightFieldOneSingles AS heatMapFourRightFieldOneSinglesAllowedHome,
      heatMapFourRightFieldOneDoubles AS heatMapFourRightFieldOneDoublesAllowedHome,
      heatMapFourRightFieldOneTriples AS heatMapFourRightFieldOneTriplesAllowedHome,
      heatMapFourRightFieldOneHomeRuns AS heatMapFourRightFieldOneHomeRunsAllowedHome,
      heatMapFourRightFieldOneHits AS heatMapFourRightFieldOneHitsAllowedHome,
      heatMapFourRightFieldSingles AS heatMapFourRightFieldSinglesAllowedHome,
      heatMapFourRightFieldTwoDoubles AS heatMapFourRightFieldTwoDoublesAllowedHome,
      heatMapFourRightFieldTwoTriples AS heatMapFourRightFieldTwoTriplesAllowedHome,
      heatMapFourRightFieldTwoHomeRuns AS heatMapFourRightFieldTwoHomeRunsAllowedHome,
      heatMapFourRightFieldTwoHits AS heatMapFourRightFieldTwoHitsAllowedHome
    FROM agg_pitching_balls_in_play_heatmaps
    WHERE
      groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_VENUEID_TEAMID_TEAMTYPE'
      AND gameType2 = 'RS'
      AND teamType = 'home'
  ),
  away_allowed AS (
    SELECT
      majorLeagueId,
      seasonId,
      venueId,
      teamId,
      -- HM4
      heatMapFourLeftFieldOneSingles AS heatMapFourLeftFieldOneSinglesAllowedAway,
      heatMapFourLeftFieldOneDoubles AS heatMapFourLeftFieldOneDoublesAllowedAway,
      heatMapFourLeftFieldOneTriples AS heatMapFourLeftFieldOneTriplesAllowedAway,
      heatMapFourLeftFieldOneHomeRuns AS heatMapFourLeftFieldOneHomeRunsAllowedAway,
      heatMapFourLeftFieldOneHits AS heatMapFourLeftFieldOneHitsAllowedAway,
      heatMapFourLeftFieldTwoDoubles AS heatMapFourLeftFieldTwoDoublesAllowedAway,
      heatMapFourLeftFieldTwoTriples AS heatMapFourLeftFieldTwoTriplesAllowedAway,
      heatMapFourLeftFieldTwoHomeRuns AS heatMapFourLeftFieldTwoHomeRunsAllowedAway,
      heatMapFourLeftFieldTwoHits AS heatMapFourLeftFieldTwoHitsAllowedAway,
      heatMapFourRightFieldOneSingles AS heatMapFourRightFieldOneSinglesAllowedAway,
      heatMapFourRightFieldOneDoubles AS heatMapFourRightFieldOneDoublesAllowedAway,
      heatMapFourRightFieldOneTriples AS heatMapFourRightFieldOneTriplesAllowedAway,
      heatMapFourRightFieldOneHomeRuns AS heatMapFourRightFieldOneHomeRunsAllowedAway,
      heatMapFourRightFieldOneHits AS heatMapFourRightFieldOneHitsAllowedAway,
      heatMapFourRightFieldSingles AS heatMapFourRightFieldSinglesAllowedAway,
      heatMapFourRightFieldTwoDoubles AS heatMapFourRightFieldTwoDoublesAllowedAway,
      heatMapFourRightFieldTwoTriples AS heatMapFourRightFieldTwoTriplesAllowedAway,
      heatMapFourRightFieldTwoHomeRuns AS heatMapFourRightFieldTwoHomeRunsAllowedAway,
      heatMapFourRightFieldTwoHits AS heatMapFourRightFieldTwoHitsAllowedAway
    FROM agg_pitching_balls_in_play_heatmaps
    WHERE
      groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_TEAMID_TEAMTYPE'
      AND gameType2 = 'RS'
      AND teamType = 'away'
  )
SELECT
  hs.groupingId,
  hs.groupingDescription,
  hs.majorLeagueId,
  hs.seasonId,
  hs.venueId,
  hs.teamId,
  homeGames,
  awayGames,
  heatMapFourLeftFieldOneSinglesScoredHome,
  heatMapFourLeftFieldOneDoublesScoredHome,
  heatMapFourLeftFieldOneTriplesScoredHome,
  heatMapFourLeftFieldOneHomeRunsScoredHome,
  heatMapFourLeftFieldOneHitsScoredHome,
  heatMapFourLeftFieldTwoDoublesScoredHome,
  heatMapFourLeftFieldTwoTriplesScoredHome,
  heatMapFourLeftFieldTwoHomeRunsScoredHome,
  heatMapFourLeftFieldTwoHitsScoredHome,
  heatMapFourRightFieldOneSinglesScoredHome,
  heatMapFourRightFieldOneDoublesScoredHome,
  heatMapFourRightFieldOneTriplesScoredHome,
  heatMapFourRightFieldOneHomeRunsScoredHome,
  heatMapFourRightFieldOneHitsScoredHome,
  heatMapFourRightFieldSinglesScoredHome,
  heatMapFourRightFieldTwoDoublesScoredHome,
  heatMapFourRightFieldTwoTriplesScoredHome,
  heatMapFourRightFieldTwoHomeRunsScoredHome,
  heatMapFourRightFieldTwoHitsScoredHome,
  heatMapFourLeftFieldOneSinglesScoredAway,
  heatMapFourLeftFieldOneDoublesScoredAway,
  heatMapFourLeftFieldOneTriplesScoredAway,
  heatMapFourLeftFieldOneHomeRunsScoredAway,
  heatMapFourLeftFieldOneHitsScoredAway,
  heatMapFourLeftFieldTwoDoublesScoredAway,
  heatMapFourLeftFieldTwoTriplesScoredAway,
  heatMapFourLeftFieldTwoHomeRunsScoredAway,
  heatMapFourLeftFieldTwoHitsScoredAway,
  heatMapFourRightFieldOneSinglesScoredAway,
  heatMapFourRightFieldOneDoublesScoredAway,
  heatMapFourRightFieldOneTriplesScoredAway,
  heatMapFourRightFieldOneHomeRunsScoredAway,
  heatMapFourRightFieldOneHitsScoredAway,
  heatMapFourRightFieldSinglesScoredAway,
  heatMapFourRightFieldTwoDoublesScoredAway,
  heatMapFourRightFieldTwoTriplesScoredAway,
  heatMapFourRightFieldTwoHomeRunsScoredAway,
  heatMapFourRightFieldTwoHitsScoredAway,
  heatMapFourLeftFieldOneSinglesAllowedHome,
  heatMapFourLeftFieldOneDoublesAllowedHome,
  heatMapFourLeftFieldOneTriplesAllowedHome,
  heatMapFourLeftFieldOneHomeRunsAllowedHome,
  heatMapFourLeftFieldOneHitsAllowedHome,
  heatMapFourLeftFieldTwoDoublesAllowedHome,
  heatMapFourLeftFieldTwoTriplesAllowedHome,
  heatMapFourLeftFieldTwoHomeRunsAllowedHome,
  heatMapFourLeftFieldTwoHitsAllowedHome,
  heatMapFourRightFieldOneSinglesAllowedHome,
  heatMapFourRightFieldOneDoublesAllowedHome,
  heatMapFourRightFieldOneTriplesAllowedHome,
  heatMapFourRightFieldOneHomeRunsAllowedHome,
  heatMapFourRightFieldOneHitsAllowedHome,
  heatMapFourRightFieldSinglesAllowedHome,
  heatMapFourRightFieldTwoDoublesAllowedHome,
  heatMapFourRightFieldTwoTriplesAllowedHome,
  heatMapFourRightFieldTwoHomeRunsAllowedHome,
  heatMapFourRightFieldTwoHitsAllowedHome,
  heatMapFourLeftFieldOneSinglesAllowedAway,
  heatMapFourLeftFieldOneDoublesAllowedAway,
  heatMapFourLeftFieldOneTriplesAllowedAway,
  heatMapFourLeftFieldOneHomeRunsAllowedAway,
  heatMapFourLeftFieldOneHitsAllowedAway,
  heatMapFourLeftFieldTwoDoublesAllowedAway,
  heatMapFourLeftFieldTwoTriplesAllowedAway,
  heatMapFourLeftFieldTwoHomeRunsAllowedAway,
  heatMapFourLeftFieldTwoHitsAllowedAway,
  heatMapFourRightFieldOneSinglesAllowedAway,
  heatMapFourRightFieldOneDoublesAllowedAway,
  heatMapFourRightFieldOneTriplesAllowedAway,
  heatMapFourRightFieldOneHomeRunsAllowedAway,
  heatMapFourRightFieldOneHitsAllowedAway,
  heatMapFourRightFieldSinglesAllowedAway,
  heatMapFourRightFieldTwoDoublesAllowedAway,
  heatMapFourRightFieldTwoTriplesAllowedAway,
  heatMapFourRightFieldTwoHomeRunsAllowedAway,
  heatMapFourRightFieldTwoHitsAllowedAway,
  -- HM4
  IF( heatMapFourLeftFieldOneSinglesScoredAway + heatMapFourLeftFieldOneSinglesAllowedAway > 0,((heatMapFourLeftFieldOneSinglesScoredHome + heatMapFourLeftFieldOneSinglesAllowedHome) / homeGames) / ((heatMapFourLeftFieldOneSinglesScoredAway + heatMapFourLeftFieldOneSinglesAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldOneSinglesParkFactor,
  IF( heatMapFourLeftFieldOneDoublesScoredAway + heatMapFourLeftFieldOneDoublesAllowedAway > 0,((heatMapFourLeftFieldOneDoublesScoredHome + heatMapFourLeftFieldOneDoublesAllowedHome) / homeGames) / ((heatMapFourLeftFieldOneDoublesScoredAway + heatMapFourLeftFieldOneDoublesAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldOneDoublesParkFactor,
  IF( heatMapFourLeftFieldOneTriplesScoredAway + heatMapFourLeftFieldOneTriplesAllowedAway > 0,((heatMapFourLeftFieldOneTriplesScoredHome + heatMapFourLeftFieldOneTriplesAllowedHome) / homeGames) / ((heatMapFourLeftFieldOneTriplesScoredAway + heatMapFourLeftFieldOneTriplesAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldOneTriplesParkFactor,
  IF( heatMapFourLeftFieldOneHomeRunsScoredAway + heatMapFourLeftFieldOneHomeRunsAllowedAway > 0,((heatMapFourLeftFieldOneHomeRunsScoredHome + heatMapFourLeftFieldOneHomeRunsAllowedHome) / homeGames) / ((heatMapFourLeftFieldOneHomeRunsScoredAway + heatMapFourLeftFieldOneHomeRunsAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldOneHomeRunsParkFactor,
  IF( heatMapFourLeftFieldOneHitsScoredAway + heatMapFourLeftFieldOneHitsAllowedAway > 0,((heatMapFourLeftFieldOneHitsScoredHome + heatMapFourLeftFieldOneHitsAllowedHome) / homeGames) / ((heatMapFourLeftFieldOneHitsScoredAway + heatMapFourLeftFieldOneHitsAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldOneHitsParkFactor,
  IF( heatMapFourLeftFieldTwoDoublesScoredAway + heatMapFourLeftFieldTwoDoublesAllowedAway > 0,((heatMapFourLeftFieldTwoDoublesScoredHome + heatMapFourLeftFieldTwoDoublesAllowedHome) / homeGames) / ((heatMapFourLeftFieldTwoDoublesScoredAway + heatMapFourLeftFieldTwoDoublesAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldTwoDoublesParkFactor,
  IF( heatMapFourLeftFieldTwoTriplesScoredAway + heatMapFourLeftFieldTwoTriplesAllowedAway > 0,((heatMapFourLeftFieldTwoTriplesScoredHome + heatMapFourLeftFieldTwoTriplesAllowedHome) / homeGames) / ((heatMapFourLeftFieldTwoTriplesScoredAway + heatMapFourLeftFieldTwoTriplesAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldTwoTriplesParkFactor,
  IF( heatMapFourLeftFieldTwoHomeRunsScoredAway + heatMapFourLeftFieldTwoHomeRunsAllowedAway > 0,((heatMapFourLeftFieldTwoHomeRunsScoredHome + heatMapFourLeftFieldTwoHomeRunsAllowedHome) / homeGames) / ((heatMapFourLeftFieldTwoHomeRunsScoredAway + heatMapFourLeftFieldTwoHomeRunsAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldTwoHomeRunsParkFactor,
  IF( heatMapFourLeftFieldTwoHitsScoredAway + heatMapFourLeftFieldTwoHitsAllowedAway > 0,((heatMapFourLeftFieldTwoHitsScoredHome + heatMapFourLeftFieldTwoHitsAllowedHome) / homeGames) / ((heatMapFourLeftFieldTwoHitsScoredAway + heatMapFourLeftFieldTwoHitsAllowedAway) / awayGames), NULL ) AS heatMapFourLeftFieldTwoHitsParkFactor,
  IF( heatMapFourRightFieldOneSinglesScoredAway + heatMapFourRightFieldOneSinglesAllowedAway > 0,((heatMapFourRightFieldOneSinglesScoredHome + heatMapFourRightFieldOneSinglesAllowedHome) / homeGames) / ((heatMapFourRightFieldOneSinglesScoredAway + heatMapFourRightFieldOneSinglesAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldOneSinglesParkFactor,
  IF( heatMapFourRightFieldOneDoublesScoredAway + heatMapFourRightFieldOneDoublesAllowedAway > 0,((heatMapFourRightFieldOneDoublesScoredHome + heatMapFourRightFieldOneDoublesAllowedHome) / homeGames) / ((heatMapFourRightFieldOneDoublesScoredAway + heatMapFourRightFieldOneDoublesAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldOneDoublesParkFactor,
  IF( heatMapFourRightFieldOneTriplesScoredAway + heatMapFourRightFieldOneTriplesAllowedAway > 0,((heatMapFourRightFieldOneTriplesScoredHome + heatMapFourRightFieldOneTriplesAllowedHome) / homeGames) / ((heatMapFourRightFieldOneTriplesScoredAway + heatMapFourRightFieldOneTriplesAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldOneTriplesParkFactor,
  IF( heatMapFourRightFieldOneHomeRunsScoredAway + heatMapFourRightFieldOneHomeRunsAllowedAway > 0,((heatMapFourRightFieldOneHomeRunsScoredHome + heatMapFourRightFieldOneHomeRunsAllowedHome) / homeGames) / ((heatMapFourRightFieldOneHomeRunsScoredAway + heatMapFourRightFieldOneHomeRunsAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldOneHomeRunsParkFactor,
  IF( heatMapFourRightFieldOneHitsScoredAway + heatMapFourRightFieldOneHitsAllowedAway > 0,((heatMapFourRightFieldOneHitsScoredHome + heatMapFourRightFieldOneHitsAllowedHome) / homeGames) / ((heatMapFourRightFieldOneHitsScoredAway + heatMapFourRightFieldOneHitsAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldOneHitsParkFactor,
  IF( heatMapFourRightFieldSinglesScoredAway + heatMapFourRightFieldSinglesAllowedAway > 0,((heatMapFourRightFieldSinglesScoredHome + heatMapFourRightFieldSinglesAllowedHome) / homeGames) / ((heatMapFourRightFieldSinglesScoredAway + heatMapFourRightFieldSinglesAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldSinglesParkFactor,
  IF( heatMapFourRightFieldTwoDoublesScoredAway + heatMapFourRightFieldTwoDoublesAllowedAway > 0,((heatMapFourRightFieldTwoDoublesScoredHome + heatMapFourRightFieldTwoDoublesAllowedHome) / homeGames) / ((heatMapFourRightFieldTwoDoublesScoredAway + heatMapFourRightFieldTwoDoublesAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldTwoDoublesParkFactor,
  IF( heatMapFourRightFieldTwoTriplesScoredAway + heatMapFourRightFieldTwoTriplesAllowedAway > 0,((heatMapFourRightFieldTwoTriplesScoredHome + heatMapFourRightFieldTwoTriplesAllowedHome) / homeGames) / ((heatMapFourRightFieldTwoTriplesScoredAway + heatMapFourRightFieldTwoTriplesAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldTwoTriplesParkFactor,
  IF( heatMapFourRightFieldTwoHomeRunsScoredAway + heatMapFourRightFieldTwoHomeRunsAllowedAway > 0,((heatMapFourRightFieldTwoHomeRunsScoredHome + heatMapFourRightFieldTwoHomeRunsAllowedHome) / homeGames) / ((heatMapFourRightFieldTwoHomeRunsScoredAway + heatMapFourRightFieldTwoHomeRunsAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldTwoHomeRunsParkFactor,
  IF( heatMapFourRightFieldTwoHitsScoredAway + heatMapFourRightFieldTwoHitsAllowedAway > 0,((heatMapFourRightFieldTwoHitsScoredHome + heatMapFourRightFieldTwoHitsAllowedHome) / homeGames) / ((heatMapFourRightFieldTwoHitsScoredAway + heatMapFourRightFieldTwoHitsAllowedAway) / awayGames), NULL ) AS heatMapFourRightFieldTwoHitsParkFactor
FROM home_scored hs
INNER JOIN away_scored aws
  ON hs.seasonId = aws.seasonId
  AND hs.majorLeagueId = aws.majorLeagueId
  AND hs.teamId = aws.teamId
INNER JOIN home_allowed ha
  ON hs.seasonId = ha.seasonId
  AND hs.majorLeagueId = ha.majorLeagueId
  AND hs.teamId = ha.teamId
  AND hs.venueId = ha.venueId
INNER JOIN away_allowed aa
  ON ha.seasonId = aa.seasonId
  AND ha.majorLeagueId = aa.majorLeagueId
  AND ha.teamId = aa.teamId;

COMMIT;

END //

DELIMITER ;
