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
    table_name,
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
    table_name,
    GROUP_CONCAT(
      CONCAT(column_name, ' ', data_type)
      ORDER BY
        ordinal_position SEPARATOR ',\n'
    ) table_structure
  FROM table_col_types
  GROUP BY
    1
)
SELECT
  table_name tbl_name,
  CONCAT(
    'DROP TABLE IF EXISTS ',
    table_name,
    '; \n\nCREATE TABLE ',
    table_name,
    ' (\n',
    table_structure,
    '\n);'
  ) sql_stmt
FROM table_structure
"""

df = pd.read_sql_query(table_query, con=mysql_conn)
df = df.reset_index()

print(f"Exporting all tables")

for index, row in df.iterrows():
    f = open(f"{output_dir}{row['tbl_name']}.sql", "w")
    f.write(row["sql_stmt"])
    f.close()