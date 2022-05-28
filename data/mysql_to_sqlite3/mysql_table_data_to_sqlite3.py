from sqlalchemy import create_engine as ce, types
import pandas as pd


# Output Directory Specs
output_dir = "/Users/andresalvarado/Desktop/dump2/"

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
  GROUP BY
    1
)
SELECT
  tbl_name,
  'WHERE 1=1' filter
FROM d
ORDER BY
  1
"""

df = pd.read_sql_query(table_query, con=mysql_conn)
df = df.reset_index()

print(f"Exporting all tables")

for index, row in df.iterrows():
    print(
        f"Processing {row['tbl_name']}. Query: SELECT * FROM {row['tbl_name']} {row['filter']}"
    )
    df = pd.read_sql_query(
        f"""SELECT * FROM {row['tbl_name']} {row['filter']}""", con=mysql_conn
    )

    if "Unnamed: 0" in df.keys():
        del df["Unnamed: 0"]

    df.to_csv(f"{output_dir}/{row['tbl_name']}", index=False, header=False, mode="w")

    print(f"Finished processing {row['tbl_name']}.")
