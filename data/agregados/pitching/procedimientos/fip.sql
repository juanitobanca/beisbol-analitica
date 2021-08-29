USE baseball;

DROP PROCEDURE fip;

DELIMITER //

CREATE PROCEDURE fip( )
BEGIN

/* Based on
   https://web.wpi.edu/Pubs/E-project/Available/E-project-050614-141701/unrestricted/COPYforDesktopJoeMQP.pdf
   https://library.fangraphs.com/pitching/fip/
*/

/* Actualizar valores de los pesos en la tabla */
UPDATE
  agg_pitching_stats aps
INNER JOIN (
  SELECT
    majorLeagueId,
    seasonId,
    SUM(IF(event = 'Strikeout', runValue, 0)) weightStrikeout,
    SUM(IF(event = 'Hit By Pitch', runValue, 0)) weightHitByPitch,
    SUM(IF(event = 'Walk', runValue, 0)) weightUnintentionalWalk,
    SUM(IF(event = 'Single', runValue, 0)) weightSingle,
    SUM(IF(event = 'Double', runValue, 0)) weightDouble,
    SUM(IF(event = 'Triple', runValue, 0)) weightTriple,
    SUM(IF(event = 'Home Run', runValue, 0)) weightHomeRun,
    SUM(IF(event = 'Out', runValue, 0)) weightOut
  FROM rem_event_run_value
  GROUP BY
    1, 2
) w
  ON aps.majorLeagueId = w.majorLeagueId
  AND aps.seasonId = w.seasonId
  SET aps.weightStrikeout = w.weightStrikeout
  ,   aps.weightHitByPitch = w.weightHitByPitch
  ,   aps.weightUnintentionalWalk = w.weightUnintentionalWalk
  ,   aps.weightSingle = w.weightSingle
  ,   aps.weightDouble = w.weightDouble
  ,   aps.weightTriple = w.weightTriple
  ,   aps.weightHomeRun = w.weightHomeRun
  ,   aps.weightStrikeout = w.weightStrikeout
  ,   aps.weightOut = w.weightOut
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

/* Update league stats, to get value for BIP */
UPDATE
  agg_pitching_stats aps
INNER JOIN (
  SELECT
    seasonId,
    majorLeagueId,
    hitBatsmen AS leagueHitBatsmen,
    strikeOuts AS leagueStrikeOuts,
    unintentionalWalks AS leagueUnintentionalWalks,
    singles AS leagueSingles,
    doubles AS leagueDoubles,
    triples AS leagueTriples,
    homeRuns AS leagueHomeRuns,
    atbats AS leagueAtbats,
    earnedRunsPerNineInnings AS leagueEarnedRunsPerNineInnings,
    inningsPitched AS leagueInningsPitched
  FROM agg_pitching_stats
  WHERE
    groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2'
  AND aggregationType = 'AGGREGATED'

) l
  ON aps.majorLeagueId = l.majorLeagueId
  AND aps.seasonId = l.seasonId
  SET aps.leagueHitBatsmen = l.leagueHitBatsmen
  ,   aps.leagueStrikeOuts = l.leagueStrikeOuts
  ,   aps.leagueUnintentionalWalks = l.leagueUnintentionalWalks
  ,   aps.leagueSingles = l.leagueSingles
  ,   aps.leagueDoubles = l.leagueDoubles
  ,   aps.leagueTriples = l.leagueTriples
  ,   aps.leagueHomeRuns = l.leagueHomeRuns
  ,   aps.leagueAtbats = l.leagueAtbats
  ,   aps.leagueOuts =  l.leagueAtbats - l.leagueSingles - l.leagueDoubles - l.leagueTriples - l.leagueHomeRuns
  ,   aps.leagueEarnedRunsPerNineInnings = l.leagueEarnedRunsPerNineInnings
  ,   aps.leagueInningsPitched = l.leagueInningsPitched
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

/* Weight Ball In Play */
UPDATE
  agg_pitching_stats aps
  SET aps.weightBallInPlay = ( leagueSingles * weightSingle +
                               leagueDoubles * weightDouble +
                               leagueTriples * weightTriple +
                               leagueHomeRuns * weightHomeRun +
                               leagueOuts * weightOut
                              ) / leagueAtbats
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

/* Runs per Plate Appearance */
UPDATE
  agg_pitching_stats aps
INNER JOIN (
  SELECT
    majorLeagueId,
    seasonId,
    SUM(runsScoredInPlay) / COUNT(DISTINCT gamePk) / 2 AS leagueRunsPerTeamPerGame,
    SUM(isPlateAppearance) / COUNT(DISTINCT gamePk) / 2 AS leaguePlateAppearancesPerTeamPerGame
  FROM rem_play_by_play
  WHERE
    gameType2 = 'RS'
    AND (
      scheduledInnings > inning
      OR (
        scheduledInnings = inning
        AND halfInning = 'top'
      )
    )
  GROUP BY
    1, 2
) rpa
  ON aps.majorLeagueId = rpa.majorLeagueId
  AND aps.seasonId = rpa.seasonId
  SET aps.leagueRunsPerTeamPerGame = rpa.leagueRunsPerTeamPerGame
  ,   aps.leaguePlateAppearancesPerTeamPerGame = rpa.leaguePlateAppearancesPerTeamPerGame
  ,   aps.leagueRunsPerPlateAppearancePerTeamPerGame = rpa.leagueRunsPerTeamPerGame / rpa.leaguePlateAppearancesPerTeamPerGame
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

/* Get FIP Weights: Add League Runs Per Plate Appearance, then substract the weight of balls in play */
UPDATE
  agg_pitching_stats aps
INNER JOIN (
    WITH woba_weights AS (
      SELECT
        seasonId,
        majorLeagueId,
        weightStrikeOut + leagueRunsPerPlateAppearancePerTeamPerGame AS weightStrikeOut,
        weightBallInPlay + leagueRunsPerPlateAppearancePerTeamPerGame AS weightBallInPlay,
        weightUnintentionalWalk + leagueRunsPerPlateAppearancePerTeamPerGame
          AS weightUnintentionalWalk,
        weightHomeRun + leagueRunsPerPlateAppearancePerTeamPerGame AS weightHomeRun,
        leagueEarnedRunsPerNineInnings,
        leagueInningsPitched,
        leagueHomeRuns,
        leagueUnintentionalWalks,
        leagueStrikeOuts,
        leagueHitBatsmen
      FROM agg_pitching_stats
      WHERE
        groupingDescription IN('MAJORLEAGUEID_SEASONID_GAMETYPE2')
        AND gameType2 = 'RS'
        AND aggregationType = 'AGGREGATED'
    ),
      fip_weights AS (
      SELECT
        seasonId,
        majorLeagueId,
        (weightStrikeOut - weightBallInPlay) * 9 fipWeightStrikeOut,
        (weightUnintentionalWalk - weightBallInPlay) * 9 fipWeightUnintentionalWalk,
        (weightHomeRun - weightBallInPlay) * 9 fipWeightHomeRun,
        leagueEarnedRunsPerNineInnings,
        leagueHomeRuns,
        leagueUnintentionalWalks,
        leagueHitBatsmen,
        leagueStrikeOuts,
        leagueInningsPitched
      FROM woba_weights
    )
    SELECT
      seasonId,
      majorLeagueId,
      fipWeightStrikeOut,
      fipWeightUnintentionalWalk,
      fipWeightHomeRun,
      leagueEarnedRunsPerNineInnings - ( fipWeightHomeRun * leagueHomeRuns +
                                         fipWeightUnintentionalWalk * ( leagueUnintentionalWalks + leagueHitBatsmen) +
                                        fipWeightStrikeOut * leagueStrikeOuts
                                       ) / leagueInningsPitched fipConstant
    FROM fip_weights
  ) AS fp
  ON aps.majorLeagueId = fp.majorLeagueId
  AND aps.seasonId = fp.seasonId
  SET aps.fipWeightStrikeOut = fp.fipWeightStrikeOut
  ,   aps.fipWeightUnintentionalWalk = fp.fipWeightUnintentionalWalk
  ,   aps.fipWeightHomeRun = fp.fipWeightHomeRun
  ,   aps.fipConstant = fp.fipConstant
  WHERE groupingDescription IN( 'MAJORLEAGUEID_SEASONID_GAMETYPE2',
                                'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
                              )
  AND aggregationType = 'AGGREGATED';

/* FIP */
UPDATE
  agg_pitching_stats
  SET fieldIndepedentPitching = IF( inningsPitched > 0, ( fipWeightHomeRun * homeRuns +
                                                          fipWeightUnintentionalWalk * ( walks + hitBatsmen ) +
                                                          fipWeightStrikeOut * strikeOuts
                                                        ) / inningsPitched  + fipConstant
                                  , NULL
                                  )
  WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_GAMETYPE2_PLAYERID'
  AND aggregationType = 'AGGREGATED';

COMMIT;

END //

DELIMITER ;
