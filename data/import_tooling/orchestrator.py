import os
import sqlite3
import click
from util.mlb_stats_api import fetch_gamePks_for_date_range, download_game_data, user_prompt
from util.sqlite_helpers import run_query, copy_into_table, create_table
from util.transformations import transform_file_into_dict

# ---------------------------------------------------------------------------------------
# 1. Get all gamePks for a given daterange
# ---------------------------------------------------------------------------------------
gamePks = fetch_gamePks_for_date_range(start_date="05/01/2022", end_date="05/25/2022")
print(gamePks)
# ---------------------------------------------------------------------------------------
# # 2. Download gameday data for each gamePk
# ---------------------------------------------------------------------------------------
for gamePk in gamePks:
    gamePk_file = f"data/import_tooling/source_data/game_{gamePk}.json"
    if gamePk == gamePks[0]:
        if os.path.exists(gamePk_file):
            if not click.confirm(user_prompt, default=True):
                print(f"Skipping download of {len(gamePks)} files.")
                break
    gamePk_filepath = os.path.join(os.getcwd(), gamePk_file)
    download_game_data(gamePk=gamePk, local_filepath=gamePk_filepath)
# ---------------------------------------------------------------------------------------
# 3-5. Parse, Format, and Load data to Sqlite DB
# ---------------------------------------------------------------------------------------
conn = sqlite3.connect("my_local.db")
schema_types_path = "data/import_tooling/source_table_schemas"
for gamePk in gamePks:
    gamePk_file = f"data/import_tooling/source_data/game_{gamePk}.json"
    for schema_type in os.listdir(schema_types_path):
        schema_path = os.path.join(schema_types_path, schema_type)
        for schema in os.listdir(schema_path):
            table_name = schema[:-5]
            schema_file = os.path.join(schema_path, schema)
            # -------------------------------------------------------------------------------
            # 3. Parse gameday data into DataFrames (to match ERD diagram's schemas)
            # -------------------------------------------------------------------------------
            data, table_schema = transform_file_into_dict(gamePk_file=gamePk_file, schema_file=schema_file, schema_type=schema_type)
            # print(data)
            # -------------------------------------------------------------------------------
            # 4. Create each table using ERD schemas
            # -------------------------------------------------------------------------------
            if gamePk == gamePks[0]:
                create_table(conn=conn, table_name=table_name, table_schema=table_schema)
            # -------------------------------------------------------------------------------
            # 5. Load each of the Dataframes into a SQLite Database
            # -------------------------------------------------------------------------------
            formatted_data = [tuple(row.values()) for row in data.values()]
            copy_into_table(conn=conn, data=formatted_data, table_name=table_name, table_schema=table_schema)
# ---------------------------------------------------------------------------------------
# 6. Preview data in SQLite Table
# ---------------------------------------------------------------------------------------
for schema_type in os.listdir(schema_types_path):
    schema_path = os.path.join(schema_types_path, schema_type)
    for schema in os.listdir(schema_path):
        table_name = schema[:-5]
        sql = f"SELECT * FROM {table_name} LIMIT 10;"
        results = run_query(sql, conn)
        for result in results:
            print(result)
        print(("~~~~~~~"*20 + "\n") *3)
