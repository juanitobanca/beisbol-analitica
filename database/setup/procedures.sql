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
.read ./data/base/procedimientos/game_batting_orders.sql

.print "Running: games.sql"
.read ./data/base/procedimientos/games.sql

.print "Running: players.sql"
.read ./data/base/procedimientos/players.sql

.print "Running: officials.sql"
.read ./data/base/procedimientos/officials.sql

.print "Running: game_player_batting_stats.sql"
.read ./data/base/procedimientos/game_player_batting_stats.sql

.print "Running: game_player_fielding_stats.sql"
.read ./data/base/procedimientos/game_player_fielding_stats.sql

.print "Running: game_player_pitching_stats.sql"
.read ./data/base/procedimientos/game_player_pitching_stats.sql

.print "Running: game_player_positions.sql"
.read ./data/base/procedimientos/game_player_positions.sql

.print "Running: atbats.sql"
.read ./data/base/procedimientos/atbats.sql

.print "Running: pitches.sql"
.read ./data/base/procedimientos/pitches.sql

.print "Running: runners.sql"
.read ./data/base/procedimientos/runners.sql

.print "Running: fielding_credits.sql"
.read ./data/base/procedimientos/fielding_credits.sql

.print "Running: actions.sql"
.read ./data/base/procedimientos/actions.sql

.print "Running: pickoffs.sql"
.read ./data/base/procedimientos/pickoffs.sql

.print "Running: game_officials.sql"
.read ./data/base/procedimientos/game_officials.sql

.print "Running: transactions.sql"
.read ./data/base/procedimientos/transactions.sql

.print "Running: defensive_substitutions.sql"
.read ./data/base/procedimientos/defensive_substitutions.sql

.print "Running: game_player_fielding_outs.sql"
.read ./data/base/procedimientos/game_player_fielding_outs.sql

.print "Running: game_battery_fielding_stats.sql"
.read ./data/base/procedimientos/game_battery_fielding_stats.sql

.print "Running: game_player_split_stats.sql"
.read ./data/base/procedimientos/game_player_split_stats.sql

.print "Running: game_player_balls_in_play_heatmaps.sql"
.read ./data/base/procedimientos/game_player_balls_in_play_heatmaps.sql

.print "Running: major_leagues.sql"
.read ./data/base/procedimientos/major_leagues.sql

-- ========================
-- Run Expectancy
-- ========================
.print "Running: rem_play_by_play.sql"
.read ./data/run_expectancy/procedimientos/rem_play_by_play.sql

.print "Running: rem_run_expectancy_matrix.sql"
.read ./data/run_expectancy/procedimientos/rem_run_expectancy_matrix.sql

.print "Running: rem_event_run_value.sql"
.read ./data/run_expectancy/procedimientos/rem_event_run_value.sql

-- ========================
-- Win Expectancy
-- ========================
.print "Running: we_win_expectancy.sql"
.read ./data/win_expectancy/procedimientos/we_win_expectancy.sql

-- ========================
-- Win Probability Added
-- ========================
.print "Running: we_win_probability_added.sql"
.read ./data/win_expectancy/procedimientos/we_win_probability_added.sql

-- ========================
-- Aggregated Team Performance Stats
-- ========================
.print "Running: agg_team_performance_stats.sql"
.read ./data/agregados/team_performance/procedimientos/agg_team_performance_stats.sql

.print "Running: agg_team_performance_stats_derived_metrics.sql"
.read ./data/agregados/team_performance/procedimientos/agg_team_performance_derived_metrics.sql

-- ========================
-- Aggregated Batting Stats
-- ========================
.print "Running: agg_batting_stats.sql"
.read ./data/agregados/batting/procedimientos/agg_batting_stats.sql

.print "Running: agg_batting_balls_in_play_heatmaps.sql"
.read ./data/agregados/batting/procedimientos/agg_batting_balls_in_play_heatmaps.sql

.print "Running: agg_batting_split_stats.sql"
.read ./data/agregados/batting/procedimientos/agg_batting_split_stats.sql

.print "Running: agg_batting_derived_metrics.sql"
.read ./data/agregados/batting/procedimientos/agg_batting_derived_metrics.sql

.print "Running: woba.sql"
.read ./data/agregados/batting/procedimientos/woba.sql

.print "Running: wraa.sql"
.read ./data/agregados/batting/procedimientos/wraa.sql

.print "Running: wrc.sql"
.read ./data/agregados/batting/procedimientos/wrc.sql

.print "Running: ops_plus.sql"
.read ./data/agregados/batting/procedimientos/ops_plus.sql

-- ========================
-- Aggregated Pitching Stats
-- ========================
.print "Running: agg_pitching_stats.sql"
.read ./data/agregados/pitching/procedimientos/agg_pitching_stats.sql

.print "Running: agg_pitching_balls_in_play_heatmaps.sql"
.read ./data/agregados/pitching/procedimientos/agg_pitching_balls_in_play_heatmaps.sql

.print "Running: agg_pitching_split_stats.sql"
.read ./data/agregados/pitching/procedimientos/agg_pitching_split_stats.sql

.print "Running: agg_pitching_derived_metrics.sql"
.read ./data/agregados/pitching/procedimientos/agg_pitching_derived_metrics.sql

.print "Running: fip.sql"
.read ./data/agregados/pitching/procedimientos/fip.sql

-- ========================
-- Aggregated Fielding Stats
-- ========================
.print "Running: agg_fielding_stats.sql"
.read ./data/agregados/fielding/procedimientos/agg_fielding_stats.sql

.print "Running: agg_fielding_derived_metrics.sql"
.read ./data/agregados/fielding/procedimientos/agg_fielding_derived_metrics.sql

-- ========================
-- Park Factors
-- ========================
.print "Running: pf_park_factors.sql"
.read ./data/park_factors/procedimientos/pf_park_factors.sql

.print "Running: pf_heat_map_park_factors.sql"
.read ./data/park_factors/procedimientos/pf_heat_map_park_factors.sql

-- ========================
-- Update Attributes on Agg Tables
-- ========================
.print "Running: update_table_attributes.sql"
.read ./data/commons/procedimientos/update_table_attributes.sql
