-- master_procedure.sql
-- Run this from the SQLite3 CLI with:
--   sqlite3 your_database.db ".read master_procedure.sql"
-- All .sql files must be in the same directory as this file.

-- Enable error logging (SQLite CLI will print errors but continue)
.bail off

-- ========================
-- Base Tables
-- ========================
.print "Running: game_batting_orders.sql"
.read game_batting_orders.sql

.print "Running: games.sql"
.read games.sql

.print "Running: players.sql"
.read players.sql

.print "Running: officials.sql"
.read officials.sql

.print "Running: game_player_batting_stats.sql"
.read game_player_batting_stats.sql

.print "Running: game_player_fielding_stats.sql"
.read game_player_fielding_stats.sql

.print "Running: game_player_pitching_stats.sql"
.read game_player_pitching_stats.sql

.print "Running: game_player_positions.sql"
.read game_player_positions.sql

.print "Running: atbats.sql"
.read atbats.sql

.print "Running: pitches.sql"
.read pitches.sql

.print "Running: runners.sql"
.read runners.sql

.print "Running: fielding_credits.sql"
.read fielding_credits.sql

.print "Running: actions.sql"
.read actions.sql

.print "Running: pickoffs.sql"
.read pickoffs.sql

.print "Running: game_officials.sql"
.read game_officials.sql

.print "Running: transactions.sql"
.read transactions.sql

.print "Running: defensive_substitutions.sql"
.read defensive_substitutions.sql

.print "Running: game_player_fielding_outs.sql"
.read game_player_fielding_outs.sql

.print "Running: game_battery_fielding_stats.sql"
.read game_battery_fielding_stats.sql

.print "Running: game_player_split_stats.sql"
.read game_player_split_stats.sql

.print "Running: game_player_balls_in_play_heatmaps.sql"
.read game_player_balls_in_play_heatmaps.sql

.print "Running: major_leagues.sql"
.read major_leagues.sql

-- ========================
-- Run Expectancy
-- ========================
.print "Running: rem_play_by_play.sql"
.read rem_play_by_play.sql

.print "Running: rem_run_expectancy_matrix.sql"
.read rem_run_expectancy_matrix.sql

.print "Running: rem_event_run_value.sql"
.read rem_event_run_value.sql

-- ========================
-- Win Expectancy
-- ========================
.print "Running: we_win_expectancy.sql"
.read we_win_expectancy.sql

-- ========================
-- Win Probability Added
-- NOTE: we_win_probability_added.sql used dynamic SQL parameters in MySQL.
-- You will need to expand each call as a separate static SQL file or
-- inline the logic directly. See comments below for the original parameter sets.
--
-- Original calls:
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,runnerId',        'majorLeagueId,seasonId,gameType2,playerId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,batterId',         'majorLeagueId,seasonId,gameType2,playerId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,pitcherId',        'majorLeagueId,seasonId,gameType2,playerId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,battingTeamId',    'majorLeagueId,seasonId,gameType2,teamId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,pitchingTeamId',   'majorLeagueId,seasonId,gameType2,teamId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,battingTeamId,runnerId',  'majorLeagueId,seasonId,gameType2,teamId,playerId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,battingTeamId,batterId',  'majorLeagueId,seasonId,gameType2,teamId,playerId' )
--   we_win_probability_added( 'majorLeagueId,seasonId,gameType2,pitchingTeamId,pitcherId','majorLeagueId,seasonId,gameType2,teamId,playerId' )
-- ========================
.print "Running: we_win_probability_added.sql"
.read we_win_probability_added.sql

-- ========================
-- Aggregated Team Performance Stats
-- NOTE: agg_team_performance_stats.sql used dynamic SQL in MySQL (AGGREGATED + CUMULATIVE modes).
-- Split into separate static files or handle grouping inline.
-- ========================
.print "Running: agg_team_performance_stats.sql"
.read agg_team_performance_stats.sql

.print "Running: agg_team_performance_stats_derived_metrics.sql"
.read agg_team_performance_stats_derived_metrics.sql

-- ========================
-- Aggregated Batting Stats
-- ========================
.print "Running: agg_batting_stats.sql"
.read agg_batting_stats.sql

.print "Running: agg_batting_balls_in_play_heatmaps.sql"
.read agg_batting_balls_in_play_heatmaps.sql

.print "Running: agg_batting_split_stats.sql"
.read agg_batting_split_stats.sql

.print "Running: agg_batting_derived_metrics.sql"
.read agg_batting_derived_metrics.sql

.print "Running: woba.sql"
.read woba.sql

.print "Running: wraa.sql"
.read wraa.sql

.print "Running: wrc.sql"
.read wrc.sql

.print "Running: ops_plus.sql"
.read ops_plus.sql

-- ========================
-- Aggregated Pitching Stats
-- ========================
.print "Running: agg_pitching_stats.sql"
.read agg_pitching_stats.sql

.print "Running: agg_pitching_balls_in_play_heatmaps.sql"
.read agg_pitching_balls_in_play_heatmaps.sql

.print "Running: agg_pitching_split_stats.sql"
.read agg_pitching_split_stats.sql

.print "Running: agg_pitching_derived_metrics.sql"
.read agg_pitching_derived_metrics.sql

.print "Running: fip.sql"
.read fip.sql

-- ========================
-- Aggregated Fielding Stats
-- ========================
.print "Running: agg_fielding_stats.sql"
.read agg_fielding_stats.sql

.print "Running: agg_fielding_derived_metrics.sql"
.read agg_fielding_derived_metrics.sql

-- ========================
-- Park Factors
-- ========================
.print "Running: pf_park_factors.sql"
.read pf_park_factors.sql

.print "Running: pf_heat_map_park_factors.sql"
.read pf_heat_map_park_factors.sql

-- ========================
-- Update Attributes on Agg Tables
-- NOTE: update_table_attributes used dynamic SQL in MySQL.
-- Each table's attribute updates should be inlined as static UPDATE statements.
-- Tables affected:
--   agg_batting_stats, agg_pitching_split_stats, agg_pitching_stats,
--   agg_pitching_balls_in_play_heatmaps, agg_fielding_stats,
--   pf_park_factors, pf_heat_map_park_factors, agg_team_performance_stats,
--   rem_event_run_value, rem_run_expectancy_matrix
-- ========================
.print "Running: update_table_attributes.sql"
.read update_table_attributes.sql

-- ========================
-- Clean Staging Tables
-- ========================
.print "Running: clean_staging_tables.sql"
.read clean_staging_tables.sql

.print "Done! All scripts completed."
