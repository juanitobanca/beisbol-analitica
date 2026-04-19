-- Procedure: fip

/* Based on
   https://web.wpi.edu/Pubs/E-project/Available/E-project-050614-141701/unrestricted/COPYforDesktopJoeMQP.pdf
   https://library.fangraphs.com/pitching/fip/
*/

/* Actualizar valores de los pesos en la tabla */
UPDATE agg_pitching_stats
SET weightStrikeout = (SELECT SUM(CASE WHEN event = 'Strikeout' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightHitByPitch = (SELECT SUM(CASE WHEN event = 'Hit By Pitch' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightUnintentionalWalk = (SELECT SUM(CASE WHEN event = 'Walk' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightSingle = (SELECT SUM(CASE WHEN event = 'Single' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightDouble = (SELECT SUM(CASE WHEN event = 'Double' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightTriple = (SELECT SUM(CASE WHEN event = 'Triple' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightHomeRun = (SELECT SUM(CASE WHEN event = 'Home Run' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId),
    weightOut = (SELECT SUM(CASE WHEN event = 'Out' THEN runValue ELSE 0 END) FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId)
WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                               'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                             )
AND aggregationType = 'AGGREGATED'
AND EXISTS (SELECT 1 FROM rem_event_run_value WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND rem_event_run_value.majorLeagueId = agg_pitching_stats.majorLeagueId AND rem_event_run_value.seasonId = agg_pitching_stats.seasonId);

/* Update league stats, to get value for BIP */
UPDATE agg_pitching_stats
SET leagueHitBatsmen = (SELECT hitBatsmen FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueStrikeOuts = (SELECT strikeOuts FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueUnintentionalWalks = (SELECT unintentionalWalks FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueSingles = (SELECT singles FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueDoubles = (SELECT doubles FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueTriples = (SELECT triples FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueHomeRuns = (SELECT homeRuns FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueAtBats = (SELECT atbats FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueOuts = (SELECT atbats - singles - doubles - triples - homeRuns FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueEarnedRunsPerNineInnings = (SELECT earnedRunsPerNineInnings FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId),
    leagueInningsPitched = (SELECT inningsPitched FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId)
WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                               'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                             )
AND aggregationType = 'AGGREGATED'
AND EXISTS (SELECT 1 FROM agg_pitching_stats l WHERE l.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2' AND l.aggregationType = 'AGGREGATED' AND l.majorLeagueId = agg_pitching_stats.majorLeagueId AND l.seasonId = agg_pitching_stats.seasonId);

/* Weight Ball In Play */
UPDATE
  agg_pitching_stats
  SET weightBallInPlay = ( leagueSingles * weightSingle +
                               leagueDoubles * weightDouble +
                               leagueTriples * weightTriple +
                               leagueHomeRuns * weightHomeRun +
                               leagueOuts * weightOut
                              ) * 1.0 / leagueAtbats
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

/* Runs per Plate Appearance */
UPDATE agg_pitching_stats
SET leagueRunsPerTeamPerGame = (
      SELECT SUM(runsScoredInPlay) * 1.0 / COUNT(DISTINCT gamePk) / 2
      FROM rem_play_by_play
      WHERE gameType2 = 'RS'
        AND (scheduledInnings > inning OR (scheduledInnings = inning AND halfInning = 'top'))
        AND rem_play_by_play.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND rem_play_by_play.seasonId = agg_pitching_stats.seasonId
    ),
    leaguePlateAppearancesPerTeamPerGame = (
      SELECT SUM(isPlateAppearance) * 1.0 / COUNT(DISTINCT gamePk) / 2
      FROM rem_play_by_play
      WHERE gameType2 = 'RS'
        AND (scheduledInnings > inning OR (scheduledInnings = inning AND halfInning = 'top'))
        AND rem_play_by_play.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND rem_play_by_play.seasonId = agg_pitching_stats.seasonId
    ),
    leagueRunsPerPlateAppearancePerTeamPerGame = (
      SELECT (SUM(runsScoredInPlay) * 1.0 / COUNT(DISTINCT gamePk) / 2) / (SUM(isPlateAppearance) * 1.0 / COUNT(DISTINCT gamePk) / 2)
      FROM rem_play_by_play
      WHERE gameType2 = 'RS'
        AND (scheduledInnings > inning OR (scheduledInnings = inning AND halfInning = 'top'))
        AND rem_play_by_play.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND rem_play_by_play.seasonId = agg_pitching_stats.seasonId
    )
WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                               'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                             )
AND aggregationType = 'AGGREGATED'
AND EXISTS (
  SELECT 1 FROM rem_play_by_play
  WHERE gameType2 = 'RS'
    AND (scheduledInnings > inning OR (scheduledInnings = inning AND halfInning = 'top'))
    AND rem_play_by_play.majorLeagueId = agg_pitching_stats.majorLeagueId
    AND rem_play_by_play.seasonId = agg_pitching_stats.seasonId
);

/* Get FIP Weights: Add League Runs Per Plate Appearance, then substract the weight of balls in play */
UPDATE agg_pitching_stats
SET fipWeightStrikeOut = (
      SELECT (weightStrikeOut + leagueRunsPerPlateAppearancePerTeamPerGame - (weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame)) * 9
      FROM agg_pitching_stats fp
      WHERE fp.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND fp.gameType2 = 'RS'
        AND fp.aggregationType = 'AGGREGATED'
        AND fp.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND fp.seasonId = agg_pitching_stats.seasonId
    ),
    fipWeightUnintentionalWalk = (
      SELECT (weightUnintentionalWalk + leagueRunsPerPlateAppearancePerTeamPerGame - (weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame)) * 9
      FROM agg_pitching_stats fp
      WHERE fp.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND fp.gameType2 = 'RS'
        AND fp.aggregationType = 'AGGREGATED'
        AND fp.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND fp.seasonId = agg_pitching_stats.seasonId
    ),
    fipWeightHomeRun = (
      SELECT (weightHomeRun + leagueRunsPerPlateAppearancePerTeamPerGame - (weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame)) * 9
      FROM agg_pitching_stats fp
      WHERE fp.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND fp.gameType2 = 'RS'
        AND fp.aggregationType = 'AGGREGATED'
        AND fp.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND fp.seasonId = agg_pitching_stats.seasonId
    ),
    fipConstant = (
      SELECT leagueEarnedRunsPerNineInnings - (
        (weightHomeRun + leagueRunsPerPlateAppearancePerTeamPerGame - (weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame)) * 9 * leagueHomeRuns +
        (weightUnintentionalWalk + leagueRunsPerPlateAppearancePerTeamPerGame - (weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame)) * 9 * ( leagueUnintentionalWalks + leagueHitBatsmen) +
        (weightStrikeOut + leagueRunsPerPlateAppearancePerTeamPerGame - (weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame)) * 9 * leagueStrikeOuts
      ) * 1.0 / leagueInningsPitched
      FROM agg_pitching_stats fp
      WHERE fp.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
        AND fp.gameType2 = 'RS'
        AND fp.aggregationType = 'AGGREGATED'
        AND fp.majorLeagueId = agg_pitching_stats.majorLeagueId
        AND fp.seasonId = agg_pitching_stats.seasonId
    )
WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                               'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                             )
AND aggregationType = 'AGGREGATED'
AND EXISTS (
  SELECT 1 FROM agg_pitching_stats fp
  WHERE fp.groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
    AND fp.gameType2 = 'RS'
    AND fp.aggregationType = 'AGGREGATED'
    AND fp.majorLeagueId = agg_pitching_stats.majorLeagueId
    AND fp.seasonId = agg_pitching_stats.seasonId
);

/* FIP */
UPDATE
  agg_pitching_stats
  SET fieldIndepedentPitching = CASE WHEN inningsPitched > 0 THEN ( fipWeightHomeRun * homeRuns +
                                                          fipWeightUnintentionalWalk * ( walks + hitBatsmen ) +
                                                          fipWeightStrikeOut * strikeOuts
                                                        ) * 1.0 / inningsPitched  + fipConstant
                                  ELSE NULL
                                  END
  WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
  AND aggregationType = 'AGGREGATED';
