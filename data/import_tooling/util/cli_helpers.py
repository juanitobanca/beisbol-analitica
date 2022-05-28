import argparse
from operator import le
from tarfile import GNU_FORMAT
import click

user_prompt = """
    > It seems like you already have some of the files.

    > Do you wish to proceed with download?
    (y/n) -> (download/skip)
"""


def prompt_user_about_download(file_count):
    """
    Prompt a user about downloading data, since they have atleast one of files already.
    """
    if not click.confirm(user_prompt, default=True):
        print(f"Skipping download of {file_count} files.")
        return True
    return False


def format_args(input_args):
    """
    Transform user input args from strings to their actual types.
    """
    start_date = "05/24/2022"
    end_date = "05/25/2022"
    leagues = [
        "American League",
        "National League",
    ]
    teams = []
    if input_args.start_date is not None:
        start_date = input_args.start_date
        print(f"Parsed Start Date: {start_date}")
    if input_args.end_date is not None:
        end_date = input_args.end_date
        print(f"Parsed End Date: {end_date}")
    if input_args.teams is not None:
        teams = input_args.teams.split(",")
        print(f"Parsed Teams: {teams}")
    if input_args.leagues is not None:
        leagues = input_args.leagues.split(",")
        print(f"Parsed Leagues: {leagues}")
    return start_date, end_date, leagues, teams


def fetch_input_args():
    """
    Parse user input args from the command line into variables.
    """
    parser = argparse.ArgumentParser("simple_example")
    parser.add_argument(
        "--start_date", help="The oldest date to consider, Format: \"'MM/DD/YYYY'\")"
    )
    parser.add_argument(
        "--end_date", help="The most recent date to consider, Format: \"'MM/DD/YYYY'\")"
    )
    parser.add_argument(
        "--teams", help="MLB team names, Format: \"'BOS Red Sox,MIL Brewers'\")"
    )
    parser.add_argument(
        "--leagues",
        help="MLB league names, Format: \"'American League,National League'\")",
    )
    input_args = parser.parse_args()
    return format_args(input_args=input_args)
