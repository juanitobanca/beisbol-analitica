-- Tables
-- Stg
.read ./database/staging/tablas/stg_box_player_pitching.sql
.read ./database/staging/tablas/stg_box_player_game_positions.sql
.read ./database/staging/tablas/stg_transactions.sql
.read ./database/staging/tablas/stg_play_credit.sql
.read ./database/staging/tablas/stg_players.sql
.read ./database/staging/tablas/stg_play_atbat.sql
.read ./database/staging/tablas/stg_box_player_fielding.sql
.read ./database/staging/tablas/stg_officials.sql
.read ./database/staging/tablas/stg_play_runner.sql
.read ./database/staging/tablas/stg_box_player_game_info.sql
.read ./database/staging/tablas/stg_box_officials.sql
.read ./database/staging/tablas/stg_box_player_batting.sql
.read ./database/staging/tablas/stg_play_action.sql
.read ./database/staging/tablas/stg_box_team_batting_order.sql
.read ./database/staging/tablas/stg_box_team_fielding.sql
.read ./database/staging/tablas/stg_play_pickoff.sql
.read ./database/staging/tablas/stg_game_context.sql
.read ./database/staging/tablas/stg_play_pitch.sql
.read ./database/staging/tablas/stg_box_team.sql
.read ./database/staging/tablas/stg_box_info.sql
.read ./database/staging/tablas/stg_box_team_pitching.sql
.read ./database/staging/tablas/stg_box_team_batting.sql

-- Base
.read ./database/base/tablas/game_officials.sql
.read ./database/base/tablas/officials.sql
.read ./database/base/tablas/game_player_split_stats.sql
.read ./database/base/tablas/game_battery_fielding_stats.sql
.read ./database/base/tablas/atbats.sql
.read ./database/base/tablas/pitches.sql
.read ./database/base/tablas/game_player_pitching_stats.sql
.read ./database/base/tablas/fielding_credits.sql
.read ./database/base/tablas/pickoffs.sql
.read ./database/base/tablas/game_player_fielding_outs.sql
.read ./database/base/tablas/transactions.sql
.read ./database/base/tablas/game_player_fielding_stats.sql
.read ./database/base/tablas/actions.sql
.read ./database/base/tablas/game_player_batting_stats.sql
.read ./database/base/tablas/game_player_balls_in_play_heatmaps.sql
.read ./database/base/tablas/games.sql
.read ./database/base/tablas/players.sql
.read ./database/base/tablas/game_batting_orders.sql
.read ./database/base/tablas/runners.sql
.read ./database/base/tablas/defensive_substitutions.sql
.read ./database/base/tablas/game_player_positions.sql
.read ./database/base/tablas/major_leagues.sql

-- Park Factors
.read ./database/park_factors/tablas/pf_heat_map_park_factors.sql
.read ./database/park_factors/tablas/pf_park_factors.sql

-- Run Expectancy
.read ./database/run_expectancy/tablas/rem_event_run_value.sql
.read ./database/run_expectancy/tablas/rem_play_by_play.sql
.read ./database/run_expectancy/tablas/rem_run_expectancy_matrix.sql

-- Win Expectancy
.read ./database/win_expectancy/tablas/we_win_probability_added.sql
.read ./database/win_expectancy/tablas/we_win_expectancy.sql

-- Aggs
.read ./database/agregados/pitching/tablas/agg_pitching_stats.sql
.read ./database/agregados/pitching/tablas/agg_pitching_split_stats.sql
.read ./database/agregados/pitching/tablas/agg_pitching_balls_in_play_heatmaps.sql
.read ./database/agregados/batting/tablas/agg_batting_balls_in_play_heatmaps.sql
.read ./database/agregados/batting/tablas/agg_batting_stats.sql
.read ./database/agregados/batting/tablas/agg_batting_split_stats.sql
.read ./database/agregados/team_performance/tablas/agg_team_performance_stats.sql
.read ./database/agregados/fielding/tablas/agg_fielding_stats.sql
