-- Tables
-- Stg
.read ./data/staging/tablas/stg_box_player_pitching.sql
.read ./data/staging/tablas/stg_box_player_game_positions.sql
.read ./data/staging/tablas/stg_transactions.sql
.read ./data/staging/tablas/stg_play_credit.sql
.read ./data/staging/tablas/stg_players.sql
.read ./data/staging/tablas/stg_play_atbat.sql
.read ./data/staging/tablas/stg_box_player_fielding.sql
.read ./data/staging/tablas/stg_officials.sql
.read ./data/staging/tablas/stg_play_runner.sql
.read ./data/staging/tablas/stg_box_player_game_info.sql
.read ./data/staging/tablas/stg_box_officials.sql
.read ./data/staging/tablas/stg_box_player_batting.sql
.read ./data/staging/tablas/stg_play_action.sql
.read ./data/staging/tablas/stg_box_team_batting_order.sql
.read ./data/staging/tablas/stg_box_team_fielding.sql
.read ./data/staging/tablas/stg_play_pickoff.sql
.read ./data/staging/tablas/stg_game_context.sql
.read ./data/staging/tablas/stg_play_pitch.sql
.read ./data/staging/tablas/stg_box_team.sql
.read ./data/staging/tablas/stg_box_info.sql
.read ./data/staging/tablas/stg_box_team_pitching.sql
.read ./data/staging/tablas/stg_box_team_batting.sql

-- Base
.read ./data/base/tablas/game_officials.sql
.read ./data/base/tablas/officials.sql
.read ./data/base/tablas/game_player_split_stats.sql
.read ./data/base/tablas/game_battery_fielding_stats.sql
.read ./data/base/tablas/atbats.sql
.read ./data/base/tablas/pitches.sql
.read ./data/base/tablas/game_player_pitching_stats.sql
.read ./data/base/tablas/fielding_credits.sql
.read ./data/base/tablas/pickoffs.sql
.read ./data/base/tablas/game_player_fielding_outs.sql
.read ./data/base/tablas/transactions.sql
.read ./data/base/tablas/game_player_fielding_stats.sql
.read ./data/base/tablas/actions.sql
.read ./data/base/tablas/game_player_batting_stats.sql
.read ./data/base/tablas/game_player_balls_in_play_heatmaps.sql
.read ./data/base/tablas/games.sql
.read ./data/base/tablas/players.sql
.read ./data/base/tablas/game_batting_orders.sql
.read ./data/base/tablas/runners.sql
.read ./data/base/tablas/defensive_substitutions.sql
.read ./data/base/tablas/game_player_positions.sql
.read ./data/base/tablas/major_leagues.sql

-- Park Factors
.read ./data/park_factors/tablas/pf_heat_map_park_factors.sql
.read ./data/park_factors/tablas/pf_park_factors.sql

-- Run Expectancy
.read ./data/run_expectancy/tablas/rem_event_run_value.sql
.read ./data/run_expectancy/tablas/rem_play_by_play.sql
.read ./data/run_expectancy/tablas/rem_run_expectancy_matrix.sql

-- Win Expectancy
.read ./data/win_expectancy/tablas/we_win_probability_added.sql
.read ./data/win_expectancy/tablas/we_win_expectancy.sql

-- Aggs
.read ./data/agregados/pitching/tablas/agg_pitching_stats.sql
.read ./data/agregados/pitching/tablas/agg_pitching_split_stats.sql
.read ./data/agregados/pitching/tablas/agg_pitching_balls_in_play_heatmaps.sql
.read ./data/agregados/batting/tablas/agg_batting_balls_in_play_heatmaps.sql
.read ./data/agregados/batting/tablas/agg_batting_stats.sql
.read ./data/agregados/batting/tablas/agg_batting_split_stats.sql
.read ./data/agregados/team_performance/tablas/agg_team_performance_stats.sql
.read ./data/agregados/fielding/tablas/agg_fielding_stats.sql
