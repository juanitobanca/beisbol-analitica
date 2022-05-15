from sqlalchemy import create_engine as ce, types
import pandas as pd


# Output Directory Specs
output_dir = "../sqlite3/tablas/"

# Connection Specs.
mysql_conn_string = (
    "mysql://juanito:banca@localhost/baseball?use_unicode=1&charset=utf8"
)
mysql_conn = ce(mysql_conn_string)

# Get all table names

print("Querying table structure from MySQL")

table_query = """
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
    GROUP_CONCAT(
    CONCAT(
      'CREATE INDEX ',
      CONCAT(REPLACE(COLUMNS, ',', '_'), '_', tbl_name),
      ' ON ',
      tbl_name,
      '(',
      COLUMNS,
      ');'
    ) SEPARATOR '\n' 
    
    ) sql_stmt
  FROM table_index_columns
  GROUP BY 1
)
SELECT
  s.tbl_name,
  CONCAT(s.sql_stmt, '\n\n', COALESCE(i.sql_stmt,'')) sql_stmt
FROM table_structure_stmt s
LEFT JOIN table_index_stmt i
  ON s.tbl_name = i.tbl_name
ORDER BY 1;
"""

df = pd.read_sql_query(table_query, con=mysql_conn)
df = df.reset_index()

print(f"Exporting all tables")

for index, row in df.iterrows():
    f = open(f"{output_dir}{row['tbl_name']}.sql", "w")
    f.write(row["sql_stmt"])
    f.close()