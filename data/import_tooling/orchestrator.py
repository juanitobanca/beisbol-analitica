import os
import requests
from pprint import pformat, pprint
import json
import sqlite3


def fetch_gamePks_for_date_range(start_date="04/01/2022", end_date="05/01/2022", leagues=["MLB",], teams=[None,]):
    """
    Fetches a list of game IDs (gamePKs) for all games played within daterange, filterable by leagues and team names.

    :param start_date: The earliest date to consider for search of games played. Format: MM/DD/YYYY
    :type start_date: Str
    :param start_date: The latest date to consider for search of games played. Format: MM/DD/YYYY
    :type start_date: Str
    :param leagues: The Baseball leagues to consider for search of games played.
    :type leagues: List[Str]
    :param teams: The Baseball team names to consider for search of games played.
    :type teams: List[Str]
    """
    url = f"https://statsapi.mlb.com/api/v1/schedule?sportId=1&startDate={start_date}&endDate={end_date}&fields=dates,date,games,gamePk"
    print(f"GET: {url}")
    response = requests.get(url)
    response_json = json.loads(response.text)
    # print(response_json)

    gamePks = []
    date_game_map = response_json["dates"]
    for date_game in date_game_map:
        curr_date = date_game["date"]
        curr_games = date_game["games"]
        print(f"Found {len(curr_games)} games for {curr_date}.")
        for game in curr_games:
            gamePks.append(game["gamePk"])
    print(f"Found a total of {len(gamePks)} in date range: [{start_date},{end_date}]")
    gamePks.sort()
    return gamePks

def download_game_data(gamePk, local_filepath):
    """
    Downloads data for a gamePk to the local filepath.

    :param gamePk: The unique ID of the game to download
    :type gamePk: Str
    :param local_filepath: The location for where to save the game data
    :type local_filepath: Str
    """
    print(f"Writing GamePk:{gamePk}'s data to {local_filepath}.")
    url = f"https://statsapi.mlb.com/api/v1.1/game/{gamePk}/feed/live"
    print(f"GET: {url}")
    response = requests.get(url)
    game_data_dict = json.loads(response.text)
    with open(local_filepath, 'w') as file_writer:
        json.dump(game_data_dict, file_writer)

def parse_game_data(gamePk_file, schema_file):
    """
    Parses game day data using table schema file.

    :param gamePk_file: The path to file containng game day data
    :type gamePk_file: Str
    :param schema_file: The path to file containing table schema
    :type schema_file: Str
    """
    parsed_data = {}
    with open(gamePk_file, "r") as game_data:
        data = json.load(game_data)
    with open(schema_file, "r") as schema_info:
        schema = json.load(schema_info)
    num_actions = len(data['liveData']['plays']['allPlays'])
    # print(f"Number of plays: {num_actions}")
    for action_id in range(num_actions):
        parsed_data[action_id] = {}
        for column in schema.keys():
            game_data_path = schema[column]["path"]
            if game_data_path:
                try:
                    parsed_data[action_id][column] = eval(game_data_path)
                except IndexError:
                    parsed_data[action_id][column] = "IndexError"
                    print(f"IndexError with parsed_data[{action_id}][{column}] in {gamePk_file}")
                except KeyError:
                    parsed_data[action_id][column] = "KeyError"
                    print(f"KeyError with parsed_data[{action_id}][{column}] in {gamePk_file}")
    return parsed_data, schema

def run_query(sql, conn):
    """
    Run a query, and return its results.

    :param sql: The query to the execute.
    :type sql: str
    :param conn: The connection to the database where query will be executed.
    :type conn: sqlite3.Connection
    """
    print(f"Running SQL:\n{sql}")
    with conn:
        cursor = conn.execute(sql)
        return cursor.fetchall()

def create_table(conn, table_name, table_schema):
    """
    Create a table, if it doesn't already exist.

    :param conn: A connection to a database, for executing queries.
    :type conn: sqlite3.Connection
    """
    sql = f"CREATE TABLE IF NOT EXISTS {table_name} ("
    for column_name, column_details in table_schema.items():
        column_type = column_details["type"]
        sql += f"\r\n\t{column_name} {column_type},"
    # remove last comma and add closing parenthesis
    sql = sql[:-1] + "\r\n);"
    print(f"Creating table {table_name}")
    results = run_query(sql, conn)
    return results

def copy_into_table(conn, data, table_name, table_schema):
    """
    Add new rows to this table.

    :param conn: A connection to a database, for executing queries.
    :type conn: sqlite3.Connection
    :param data: Rows being added to this table.
    :type data: List[Tup]
    """
    column_count = len(table_schema.keys())
    entry = "?," * (column_count - 1) + "?"
    sql = f"INSERT INTO {table_name} VALUES ({entry})"
    # print(f"Adding new rows to table {table_name}")
    # print(sql)
    with conn: 
        cursor = conn.executemany(sql, data)
        return cursor.fetchall()

game_type_mapping = [
    {
        "id" : "S",
        "description" : "Spring Training"
    },
    {
        "id" : "R",
        "description" : "Regular Season"
    },
    {
        "id" : "F",
        "description" : "Wild Card Game"
    },
    {
        "id" : "D",
        "description" : "Division Series"
    },
    {
        "id" : "L",
        "description" : "League Championship Series"
    },
    {
        "id" : "W",
        "description" : "World Series"
    },
    {
        "id" : "C",
        "description" : "Championship"
    },
    {
        "id" : "N",
        "description" : "Nineteenth Century Series"
    },
    {
        "id" : "P",
        "description" : "Playoffs"
    },
    {
        "id" : "A",
        "description" : "All-Star Game"
    },
    {
        "id" : "I",
        "description" : "Intrasquad"
    },
    {
        "id" : "E",
        "description" : "Exhibition"
    } 
]

def get_game_description(id, description_mapping=game_type_mapping):
    """
    Return the longer game description, given shorter description.


    :param id: The shortened representation of game description
    :type id: Str
    :param description_mapping: The lengthy representation of game description
    :type description_mapping: List[Dict[str,str]]
    """
    return [type["description"] for type in description_mapping if type['id'] == id][0]


# ---------------------------------------------------------------------------------------
# 1. Get all gamePks for a given daterange
# ---------------------------------------------------------------------------------------
gamePks = fetch_gamePks_for_date_range(start_date="05/01/2022", end_date="05/02/2022")
print(gamePks)
# ---------------------------------------------------------------------------------------
# # 2. Download gameday data for each gamePk
# ---------------------------------------------------------------------------------------
for gamePk in gamePks:
    gamePk_file = f"data/import_tooling/source_data/game_{gamePk}.json"
    gamePk_filepath = os.path.join(os.getcwd(), gamePk_file)
    download_game_data(gamePk=gamePk, local_filepath=gamePk_filepath)
# ---------------------------------------------------------------------------------------
# 3-5. Parse, Format, and Load data to Sqlite DB
# ---------------------------------------------------------------------------------------
conn = sqlite3.connect("my_local.db")
schema_path = "data/import_tooling/source_table_schemas"
for gamePk in gamePks:
    gamePk_file = f"data/import_tooling/source_data/game_{gamePk}.json"
    for schema in os.listdir(schema_path):
        table_name = schema[:-5]
        schema_file = os.path.join(schema_path, schema)
        # -------------------------------------------------------------------------------
        # 3. Parse gameday data into DataFrames (to match ERD diagram's schemas)
        # -------------------------------------------------------------------------------
        data, table_schema = parse_game_data(gamePk_file=gamePk_file, schema_file=schema_file)
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
for schema in os.listdir(schema_path):
    table_name = schema[:-5]
    sql = f"SELECT * FROM {table_name} LIMIT 10;"
    results = run_query(sql, conn)
    for result in results:
        print(result)
    print(("~~~~~~~"*20 + "\n") *3)