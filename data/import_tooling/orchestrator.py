import os
import requests
from pprint import pformat, pprint
import json



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
    data = {}
    schema = {}
    with open(gamePk_file, "r") as game_data:
        data = json.load(game_data)
    with open(schema_file, "r") as schema_info:
        schema = json.load(schema_info)
    num_actions = len(data['liveData']['plays']['allPlays'])
    for action_id in range(num_actions):
        data[action_id] = {}
        for column in schema.keys():
            game_data_path = schema[column]["path"]
            if game_data_path:
                data[action_id][column] = eval(game_data_path)
        pprint(data[action_id])
    return data

# ---------------------------------------------------------------------------------------
# 1. Get all gamePks for a given daterange
# ---------------------------------------------------------------------------------------
gamePks = fetch_gamePks_for_date_range(start_date="04/01/2022", end_date="04/08/2022")
# print(gamePks)
# ---------------------------------------------------------------------------------------
# # 2. Download gameday data for each gamePk
# ---------------------------------------------------------------------------------------
for gamePk in gamePks:
    gamePk_file = f"data/import_tooling/source_data/game_{gamePk}.json"
    gamePk_filepath = os.path.join(os.getcwd(), gamePk_file)
    download_game_data(gamePk=gamePk, local_filepath=gamePk_filepath)
# ---------------------------------------------------------------------------------------
# 3. Parse gameday data into DataFrames (to match ERD diagram's schemas)
# ---------------------------------------------------------------------------------------
for gamePk in gamePks:
    gamePk_file = f"data/import_tooling/source_data/game_{gamePk}.json"
    schema_path = "data/import_tooling/source_table_schemas"
    for schema in os.listdir(schema_path):
        schema_file = os.path.join(schema_path, schema)
        data = parse_game_data(gamePk_file=gamePk_file, schema_file=schema_file)
    break
# ---------------------------------------------------------------------------------------
# 3. Load each of the Dataframes into a SQLite Database
# ---------------------------------------------------------------------------------------