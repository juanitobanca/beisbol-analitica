DROP TABLE IF EXISTS game_player_positions; 

CREATE TABLE game_player_positions (
gamePk INTEGER,
teamId INTEGER,
teamType TEXT,
playerId INTEGER,
positionAbbrev TEXT
);