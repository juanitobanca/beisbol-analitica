DROP TABLE IF EXISTS stg_box_officials;

CREATE TABLE IF NOT EXISTS stg_box_officials(
  gamePk INTEGER,
  officialId INTEGER,
  position TEXT
);
