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
SELECT table_name AS tbl_name
FROM information_schema.tables
WHERE table_schema = 'baseball'
ORDER BY 1
"""

df = pd.read_sql_query(table_query, con=mysql_conn)
tables = df["tbl_name"].to_list()

'''
# Export tables to csv

print(f"Exporting all tables")

for t in tables:
    print(f"Processing {t}.")
    df = pd.read_sql_query(f"""SELECT * FROM {t}""", con=mysql_conn)

    if 'Unnamed: 0' in df.keys():
        del df['Unnamed: 0']

    df.to_csv(f"{output_dir}/{t}", index=False, mode ='w')

    print(f"Finished processing {t}.")
'''
# CSV Export to sqlite3

print("Table creation commands")

print(".mode csv")

for t in tables:
    print(f".import {t} {t}")

# Alterting tables in sqlite3 Tables

print("Primary Key commands")

index_query = """
WITH d as
(
SELECT table_name
, index_name
, GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',' ) columns
FROM information_schema.statistics
WHERE table_schema = 'baseball'
GROUP BY 1, 2
)
SELECT table_name, CONCAT('CREATE INDEX ', Concat( replace(columns, ',', '_'), '_', table_name ), ' ON ', table_name, '(', columns, ');') sql_stmt
FROM d
Order By 1
"""

df = pd.read_sql_query(index_query, con=mysql_conn)
indexes = df["sql_stmt"].to_list()

print(".open baseball.db")

for i in indexes:
    print(i)
