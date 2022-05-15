USE baseball;

DROP TABLE stg_box_info;

CREATE TABLE IF NOT EXISTS stg_box_info(
  gamePk INTEGER,
  weather VARCHAR(100),
  wind VARCHAR(100),
  attendance VARCHAR(100)
);
