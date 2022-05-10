from sqlalchemy import create_engine as ce, types
import pandas as pd


# Connection Specs.
# First create the sqlite3 Database:
# $qlllite3 baseball.db

mysql_conn_string = (
    "mysql://juanito:banca@localhost/baseball?use_unicode=1&charset=utf8"
)
mysql_conn = ce(mysql_conn_string)

sqlite3_string = "sqlite:///ptm.db"
sqlite3_engine = ce(mysql_conn_string, echo=True)
sqlite3_conn = sqlite3_engine.connect()


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

# Export tables to sqlite3

print(f"Exporting all tables")

for t in tables:
    print(f"Processing {t}.")
    df = pd.read_sql_query(f"""SELECT * FROM {t}""", con=mysql_conn)

    if 'Unnamed: 0' in df.keys():
        del df['Unnamed: 0']

    df.to_csv(t, index=False, mode ='w')

    print(f"Finished processing {t}.")

sqlite3_conn.close()

# Alterting tables in sqlite3 Tables

print("Adding Primary Keys to Tables")

index_query = """
WITH d as
(
SELECT table_name
, IF(index_name = 'PRIMARY', MD5(RAND()), index_name) index_name
, GROUP_CONCAT(column_name ORDER BY seq_in_index SEPARATOR ',' ) columns
FROM information_schema.statistics
WHERE table_schema = 'baseball'
GROUP BY 1, 2 
ORDER BY 1 
)
SELECT CONCAT('CREATE INDEX ', index_name, ' ON ', table_name, '(', columns, ');') sql_stmt
FROM d
"""

df = pd.read_sql_query(index_query, con=mysql_conn)
print(df)
indexes = df["sql_stmt"].to_list()

for i in indexes:
    print(i)

