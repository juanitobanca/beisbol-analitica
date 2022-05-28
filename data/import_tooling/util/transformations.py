import json
from util.mappings.helpers import get_game_description

def parse_game_data(ids, parsed_data, data, schema, gamePk_file):
    """
    Extracts relevant details from game data, based on schema.

    :param ids: A list of indices to loop over while fetching data for schema
    :type ids: List[]
    :param parsed_data: Dict representation of game day data
    :type parsed_data: Dict[Str, Str]
    :param data: Dict representation of raw game day data
    :type data: Dict[Str, Str]
    :param schema: Dict representation of a table schema
    :type schema: Dict[Str, Str]
    :param gamePk_file: The path to file containing game day data
    :type gamePk_file: Str
    """
    for id in ids:
        parsed_data[id] = {}
        for column in schema.keys():
            game_data_path = schema[column]["path"]
            if game_data_path:
                try:
                    parsed_data[id][column] = eval(game_data_path)
                except IndexError:
                    parsed_data[id][column] = "IndexError"
                    print(f"IndexError with parsed_data[{id}][{column}] in {gamePk_file}")
                except KeyError:
                    parsed_data[id][column] = "KeyError"
                    print(f"KeyError with parsed_data[{id}][{column}] in {gamePk_file}")
    return parsed_data

def transform_file_into_dict(gamePk_file, schema_file, schema_type):
    """
    Loads files into Dataframes and calculates ids based on table schema,
    then calls parse_game_data to retrieve game data specific to schema.

    :param gamePk_file: The path to file containing game day data
    :type gamePk_file: Str
    :param schema_file: The path to file containing table schema
    :type schema_file: Str
    :param schema_type: Type of data table (ie. granularity/interval)
    :type schema_type: Str
    """
    parsed_data = {}
    with open(gamePk_file, "r") as game_data:
        data = json.load(game_data)
    with open(schema_file, "r") as schema_info:
        schema = json.load(schema_info)
    if schema_type == "per_plate_appearance":
        ids = range(len(data['liveData']['plays']['allPlays']))
    elif schema_type == "per_game":
        if "player" in schema_file:
            if "away" in schema_file:
                ids = data['liveData']['boxscore']['teams']['away']['players'].keys()
                for player_position in ["batting", "pitching"]:
                    if player_position in schema_file:
                        ids = [id for id in ids if data['liveData']['boxscore']['teams']['away']['players'][id].get('seasonStats', None).get(player_position, None)]
            elif "home" in schema_file:
                ids = data['liveData']['boxscore']['teams']['home']['players'].keys()
                for player_position in ["batting", "pitching"]:
                    if player_position in schema_file:
                        ids = [id for id in ids if data['liveData']['boxscore']['teams']['home']['players'][id].get('seasonStats', None).get(player_position, None)]
            else:
                ids = data['gameData']['players'].keys()
        elif "official" in schema_file:
            ids = range(len(data['liveData']['boxscore']['officials']))
        else:
            ids = [0]
    elif schema_type == "per_season":
        ids = []
    parsed_data = parse_game_data(ids=ids, parsed_data=parsed_data, data=data, schema=schema, gamePk_file=gamePk_file)
    return parsed_data, schema
