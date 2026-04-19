DROP TABLE IF EXISTS game_officials;

CREATE TABLE game_officials (
  gamePk INTEGER,
  officialId INTEGER,
  position TEXT
);

CREATE INDEX IF NOT EXISTS idx_game_officials_gamePk ON game_officials(gamePk);
