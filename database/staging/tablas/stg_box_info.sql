DROP TABLE IF EXISTS stg_box_info;

CREATE TABLE IF NOT EXISTS stg_box_info(
  gamePk INTEGER,
  weather TEXT,
  wind TEXT,
  attendance TEXT
);
