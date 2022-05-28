import json
from pprint import pprint

def get_game_description(id, game_description_mapping="data/import_tooling/util/mappings/game_type_id_game_type_description.json"):
    """
    Return the longer game description, given shorter description.

    :param id: The shortened representation of game description
    :type id: Str
    :param game_description_mapping: The lengthy representation of game description
    :type game_description_mapping: List[Dict[str,str]]
    """
    with open(game_description_mapping, "r") as file:
        descriptions = json.load(file)
        return descriptions[id]


def get_team_id(name, team_name_mapping="data/import_tooling/util/mappings/team_id_team_name.json"):
    """
    Return mlb-stats API team id, given a team name.

    :param name: The actual team name
    :type name: Str
    :param team_name_mapping: Maps id to the actual team name
    :type team_name_mapping: List[Dict[int,str]]
    """
    with open(team_name_mapping, "r") as file:
        team_ids = json.load(file)
        for team_id, team_name in team_ids.items():
            if name in team_name:
                return team_id
        pprint(team_ids.values())
        raise Exception('Invalid Team Name Exception')