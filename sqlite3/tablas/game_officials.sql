DROP TABLE IF EXISTS game_officials; 

CREATE TABLE game_officials (
gamePk INTEGER,
officialId INTEGER,
position TEXT
);

CREATE INDEX gamePk_game_officials ON game_officials(gamePk);