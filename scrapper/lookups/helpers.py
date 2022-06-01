import requests
import json
import os
from pprint import pformat


url = "https://statsapi.mlb.com/api/v1/"

lookup_api_endpoints = [
    f"{url}awards",
    f"{url}baseballStats",
    f"{url}conferences",
    f"{url}divisions",
    f"{url}eventTypes",
    f"{url}fielderDetailTypes",
    f"{url}gameStatus",
    f"{url}gameTypes",
    f"{url}highLow/types",
    f"{url}hitTrajectories",
    f"{url}jobTypes",
    f"{url}languages",
    f"{url}league",
    f"{url}leagueLeaderTypes",
    f"{url}logicalEvents",
    f"{url}metrics",
    f"{url}pitchCodes",
    f"{url}pitchTypes",
    f"{url}playerStatusCodes",
    f"{url}positions",
    f"{url}reviewReasons",
    f"{url}rosterTypes",
    f"{url}runnerDetailTypes",
    f"{url}scheduleEventTypes",
    f"{url}seasons?sportId=1",
    f"{url}situationCodes",
    f"{url}sky",
    f"{url}sports",
    f"{url}standings?leagueId=103,104",
    f"{url}standingsTypes",
    f"{url}statGroups",
    f"{url}statTypes",
    f"{url}teams",
    f"{url}venues",
    f"{url}windDirection",
]

def mkdir_p(file_name):
    """
    Create any (sub)folders needed for filepath.
    """
    full_folder_path = os.path.dirname(file_name)
    if not os.path.exists(full_folder_path):
        os.makedirs(full_folder_path)
        print(f"Created folder: {full_folder_path}")

def load_lookup_tables(folder_path = "scrapper/lookups/api/"):
    """
    Download Lookup Tables from MLB Stats API.

    :param folder_path: Folder path to save json files
    :param type: Str
    """
    for lookup_url in lookup_api_endpoints:
        file_name = os.path.join(folder_path, lookup_url[len(url):] + ".json")
        mkdir_p(file_name)
        with open(file_name, "w") as file:
            json_response = json.loads(requests.get(lookup_url).text)
            json.dump(json_response, file, indent=4, sort_keys=True)

def lookupByValue(map, value):
    """
    Lookup the key associated with a value in map.

    :param map: A mapping of keys to values, typically ids to names/descriptions.
    :param type: Dict[Str,Str]
    :param value: A value in map.
    :param type: Str
    """
    if value is None:
        return value
    for k, v in map.items():
        if value in v:
            return k
    raise Exception(f"Key not found! Value: {value}, Map: {map}")

load_lookup_tables()