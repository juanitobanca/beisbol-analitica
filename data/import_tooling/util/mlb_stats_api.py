import requests
import json
from util.mappings.helpers import get_team_id

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

user_prompt = """
    > It seems like you already have some of the files.

    > Do you wish to proceed with download?
    (y/n) -> (download/skip)
"""
