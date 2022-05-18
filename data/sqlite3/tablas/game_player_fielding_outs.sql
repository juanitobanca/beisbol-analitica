DROP TABLE IF EXISTS game_player_fielding_outs; 

CREATE TABLE game_player_fielding_outs (
gamePk INTEGER,
teamId INTEGER,
playerId INTEGER,
positionAbbrev TEXT,
outs INTEGER
);

CREATE INDEX gamePk_playerId_positionAbbrev_game_player_fielding_outs ON game_player_fielding_outs(gamePk,playerId,positionAbbrev);