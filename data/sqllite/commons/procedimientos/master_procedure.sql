-- Procedure: master_procedure
-- This file orchestrates the execution of all SQL scripts in order.
-- In SQLite, there is no CALL statement. Run each referenced .sql file sequentially.

-- Base

-- Run: game_batting_orders.sql
-- Run: games.sql
-- Run: players.sql
-- Run: officials.sql
-- Run: game_player_batting_stats.sql
-- Run: game_player_fielding_stats.sql
-- Run: game_player_pitching_stats.sql
-- Run: game_player_positions.sql
-- Run: atbats.sql
-- Run: pitches.sql
-- Run: runners.sql
-- Run: fielding_credits.sql
-- Run: actions.sql
-- Run: pickoffs.sql
-- Run: game_officials.sql
-- Run: transactions.sql

-- Run: defensive_substitutions.sql
-- Run: game_player_fielding_outs.sql
-- Run: game_battery_fielding_stats.sql
-- Run: game_player_split_stats.sql
-- Run: game_player_balls_in_play_heatmaps.sql
-- Run: major_leagues.sql

-- Run Expectancy
-- Run: rem_play_by_play.sql
-- Run: rem_run_expectancy_matrix.sql
-- Run: rem_event_run_value.sql

-- Win Expectancy
-- Run: we_win_expectancy.sql

-- Win Probability Added
-- Run: we_win_probability_added.sql (requires application-layer dynamic SQL)
--   Original calls with parameters:
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,runnerId', 'majorLeagueId,seasonId,gameType2,playerId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,batterId', 'majorLeagueId,seasonId,gameType2,playerId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,pitcherId', 'majorLeagueId,seasonId,gameType2,playerId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,battingTeamId', 'majorLeagueId,seasonId,gameType2,teamId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,pitchingTeamId', 'majorLeagueId,seasonId,gameType2,teamId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,battingTeamId,runnerId', 'majorLeagueId,seasonId,gameType2,teamId,playerId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,battingTeamId,batterId', 'majorLeagueId,seasonId,gameType2,teamId,playerId', @insert_stmt )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,pitchingTeamId,pitcherId', 'majorLeagueId,seasonId,gameType2,teamId,playerId', @insert_stmt )

-- Aggregated Team Performance Stats
-- Run: agg_team_performance_stats.sql (requires application-layer dynamic SQL)
--   Original calls:
--   agg_team_performance_stats( 'majorLeagueId,seasonId,gameType2,teamId', 'AGGREGATED', @insert_stmt )
--   agg_team_performance_stats( 'majorLeagueId,seasonId,gameType2,teamId,teamType', 'AGGREGATED', @insert_stmt )

-- Cumulative Team Performance Stats
--   agg_team_performance_stats( 'majorLeagueId,seasonId,gameType2,teamId', 'CUMULATIVE', @insert_stmt )
--   agg_team_performance_stats( 'majorLeagueId,seasonId,gameType2,teamId,teamType', 'CUMULATIVE', @insert_stmt )

-- Derived Team Metrics
-- Run: agg_team_performance_stats_derived_metrics.sql

-- Aggregated Batting Stats
-- Run: agg_batting_stats.sql (requires application-layer dynamic SQL)
--   Original calls with various grouping field combinations (see original file for full list)

-- Batting Heat Maps
-- Run: agg_batting_balls_in_play_heatmaps.sql (requires application-layer dynamic SQL)

-- Cumulative Batting Stats
-- Run: agg_batting_stats.sql (CUMULATIVE mode, requires application-layer dynamic SQL)

-- Aggregated Batting Split Stats
-- Run: agg_batting_split_stats.sql (requires application-layer dynamic SQL)

-- Derived Batting metrics
-- Run: agg_batting_derived_metrics.sql
-- Run: woba.sql
-- Run: wraa.sql
-- Run: wrc.sql
-- Run: ops_plus.sql

-- Aggregated Pitching Stats
-- Run: agg_pitching_stats.sql (requires application-layer dynamic SQL)

-- Pitching Heat Maps
-- Run: agg_pitching_balls_in_play_heatmaps.sql (requires application-layer dynamic SQL)

-- Cumulative Pitching Stats
-- Run: agg_pitching_stats.sql (CUMULATIVE mode, requires application-layer dynamic SQL)

-- Aggregated Pitching Split Stats
-- Run: agg_pitching_split_stats.sql (requires application-layer dynamic SQL)

-- Derived Pitching Metrics
-- Run: agg_pitching_derived_metrics.sql
-- Run: fip.sql

-- Aggregated Fielding Stats
-- Run: agg_fielding_stats.sql (requires application-layer dynamic SQL)

-- Cumulative Fielding Stats
-- Run: agg_fielding_stats.sql (CUMULATIVE mode, requires application-layer dynamic SQL)

-- Derived Fielding Metrics
-- Run: agg_fielding_derived_metrics.sql

-- Park Factors
-- Run: pf_park_factors.sql

-- Heat Map Park Factors
-- Run: pf_heat_map_park_factors.sql

-- Update attributes on Agg Tables
-- Run: update_table_attributes.sql (requires application-layer dynamic SQL)
--   Original calls:
--   update_table_attributes('agg_batting_stats', @update_stmt)
--   update_table_attributes('agg_pitching_split_stats', @update_stmt)
--   update_table_attributes('agg_pitching_stats', @update_stmt)
--   update_table_attributes('agg_pitching_balls_in_play_heatmaps', @update_stmt)
--   update_table_attributes('agg_fielding_stats', @update_stmt)
--   update_table_attributes('pf_park_factors', @update_stmt)
--   update_table_attributes('pf_heat_map_park_factors', @update_stmt)
--   update_table_attributes('agg_team_performance_stats', @update_stmt)
--   update_table_attributes('rem_event_run_value', @update_stmt)
--   update_table_attributes('rem_run_expectancy_matrix', @update_stmt)

-- Clean Staging Tables
-- Run: clean_staging_tables.sql
