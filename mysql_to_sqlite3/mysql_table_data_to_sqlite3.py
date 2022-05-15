from sqlalchemy import create_engine as ce, types
import pandas as pd


# Output Directory Specs
output_dir = "/Users/andresalvarado/Desktop/dump/"

# Connection Specs.
mysql_conn_string = (
    "mysql://juanito:banca@localhost/baseball?use_unicode=1&charset=utf8"
)
mysql_conn = ce(mysql_conn_string)

# Get all table names

print("Querying table names from MySQL")


table_query = """
WITH d AS (
  SELECT
    table_name AS tbl_name,
    COUNT(IF(column_name = 'majorLeagueId', 1, NULL)) majorLeagueId,
    COUNT(IF(column_name = 'gamePk', 1, NULL)) gamePk,
    COUNT(IF(column_name = 'seasonId', 1, NULL)) seasonId
  FROM information_schema.columns
  WHERE
    table_schema = 'baseball'
    And Instr(table_name, 'agg') = 0
  GROUP BY
    1
)
SELECT
  tbl_name,
  CASE
    WHEN gamePk > 0
      THEN 'WHERE gamePk IN ( SELECT gamePk from games WHERE majorLeague NOT IN ( "MLB", "DSL" ) AND seasonId > 2010 )'
    WHEN majorLeagueId > 0 And seasonId = 0
      THEN 'WHERE majorLeagueId IN ( SELECT majorLeagueId FROM major_leagues WHERE majorLeague NOT IN ( "MLB", "DSL") )'
    WHEN majorLeagueId > 0 And seasonId > 0
      THEN 'WHERE majorLeagueId IN ( SELECT majorLeagueId FROM major_leagues WHERE majorLeague NOT IN ( "MLB", "DSL") ) And seasonId > 2010'
    ELSE 'WHERE 1=1'
  END filter
FROM d
ORDER BY
  1
"""

df = pd.read_sql_query(table_query, con=mysql_conn)
df = df.reset_index()

print(f"Exporting all tables")

for index, row in df.iterrows():
    print(f"Processing {row['tbl_name']}. Query: SELECT * FROM {row['tbl_name']} {row['filter']}")
    df = pd.read_sql_query(f"""SELECT * FROM {row['tbl_name']} {row['filter']}""", con=mysql_conn)

    if 'Unnamed: 0' in df.keys():
        del df['Unnamed: 0']

    df.to_csv(f"{output_dir}/{row['tbl_name']}", index=False, mode ='w')

    print(f"Finished processing {row['tbl_name']}.")


# CSV Export to sqlite3

print("Table creation commands")

print(".mode csv")

for index, row in df.iterrows():
    print(f".import {row['tbl_name']} {row['tbl_name']}")


# Alterting tables in sqlite3 Tables

print("Primary Key commands")

index_query = """
WITH table_col_types AS (
  SELECT
    table_name AS tbl_name,
    column_name,
    ordinal_position,
    CASE
      WHEN data_type IN ('bigint', 'int', 'tinyint') THEN 'INTEGER'
      WHEN data_type = 'double' THEN 'REAL'
      WHEN data_type IN ('date', 'text', 'varchar') THEN 'TEXT'
      ELSE data_type
    END data_type

  FROM information_schema.columns
  WHERE
    table_schema = 'baseball'
    AND column_name <> 'Unnamed: 0'
),
table_structure AS (
  SELECT
    tbl_name,
    GROUP_CONCAT(
      CONCAT(column_name, ' ', data_type)
      ORDER BY
        ordinal_position SEPARATOR ',\n'
    ) table_structure
  FROM table_col_types
  GROUP BY
    1
),
table_structure_stmt AS (
  SELECT
    tbl_name,
    CONCAT(
      'DROP TABLE IF EXISTS ',
      tbl_name,
      '; \n\nCREATE TABLE ',
      tbl_name,
      ' (\n',
      table_structure,
      '\n);'
    ) sql_stmt
  FROM table_structure s
),
table_index_columns AS (
  SELECT
    table_name AS tbl_name,
    index_name,
    GROUP_CONCAT(
      column_name
      ORDER BY
        seq_in_index SEPARATOR ','
    ) COLUMNS
  FROM information_schema.statistics
  WHERE
    table_schema = 'baseball'
  GROUP BY
    1, 2
),
table_index_stmt AS (
  SELECT
    tbl_name,
    CONCAT(
      'CREATE INDEX ',
      CONCAT(REPLACE(COLUMNS, ',', '_'), '_', tbl_name),
      ' ON ',
      tbl_name,
      '(',
      COLUMNS,
      ');'
    ) sql_stmt
  FROM table_index_columns
)
SELECT
  s.tbl_name,
  s.sql_stmt
FROM table_structure_stmt s
"""

df = pd.read_sql_query(index_query, con=mysql_conn)
indexes = df["sql_stmt"].to_list()

print(".open baseball.db")

for i in indexes:
    print(i)

