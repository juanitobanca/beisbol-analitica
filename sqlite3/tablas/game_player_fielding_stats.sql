DROP TABLE IF EXISTS game_player_fielding_stats; 

CREATE TABLE game_player_fielding_stats (
gamePk INTEGER,
teamId INTEGER,
teamType TEXT,
playerId INTEGER,
assists INTEGER,
caughtStealing INTEGER,
chances INTEGER,
errors INTEGER,
passedBall INTEGER,
pickoffs INTEGER,
putOuts INTEGER,
stolenBases INTEGER
);