USE baseball;

DROP TABLE stg_box_officials;

CREATE TABLE IF NOT EXISTS stg_box_officials(
  gamePk INTEGER,
  officialId INTEGER,
  position VARCHAR(100)
);
