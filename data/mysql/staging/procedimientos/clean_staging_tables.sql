USE baseball;

DROP PROCEDURE clean_staging_tables;

DELIMITER //

CREATE PROCEDURE clean_staging_tables()
BEGIN

TRUNCATE TABLE stg_players;
TRUNCATE TABLE stg_officials;
TRUNCATE TABLE stg_box_team_batting;
TRUNCATE TABLE stg_box_team_pitching;
TRUNCATE TABLE stg_box_team_fielding;
TRUNCATE TABLE stg_box_player_batting;
TRUNCATE TABLE stg_box_player_pitching;
TRUNCATE TABLE stg_box_player_fielding;
TRUNCATE TABLE stg_box_team_batting_order;
TRUNCATE TABLE stg_box_team;
TRUNCATE TABLE stg_box_player_game_positions;
TRUNCATE TABLE stg_box_player_game_info;
TRUNCATE TABLE stg_play_credit;
TRUNCATE TABLE stg_play_atbat;
TRUNCATE TABLE stg_play_action;
TRUNCATE TABLE stg_play_runner;
TRUNCATE TABLE stg_play_pitch;
TRUNCATE TABLE stg_play_pickoff;
TRUNCATE TABLE stg_game_context;
TRUNCATE TABLE stg_box_info;
TRUNCATE TABLE stg_box_officials;


END //

DELIMITER ;
