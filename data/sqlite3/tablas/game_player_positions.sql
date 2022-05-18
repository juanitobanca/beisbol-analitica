DROP TABLE IF EXISTS game_player_positions; 

CREATE TABLE game_player_positions (
gamePk INTEGER,
teamId INTEGER,
teamType TEXT,
playerId INTEGER,
positionAbbrev TEXT
);

CREATE INDEX gamePk_teamId_playerId_game_player_positions ON game_player_positions(gamePk,teamId,playerId);