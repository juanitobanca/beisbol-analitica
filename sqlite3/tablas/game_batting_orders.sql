DROP TABLE IF EXISTS game_batting_orders; 

CREATE TABLE game_batting_orders (
gamePk INTEGER,
teamId INTEGER,
playerId INTEGER,
battingOrder INTEGER
);

CREATE INDEX gamePk_teamId_playerId_game_batting_orders ON game_batting_orders(gamePk,teamId,playerId);