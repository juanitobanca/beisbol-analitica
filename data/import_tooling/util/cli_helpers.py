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
    if input_args.startDate is not None:
        start_date = input_args.startDate
        print(f"Parsed Start Date: {start_date}")
    if input_args.endDate is not None:
        end_date = input_args.endDate
        print(f"Parsed End Date: {end_date}")
    if input_args.batch is not None:
        batch = input_args.batch
        print(f"Parsed Batch: {batch}")
    if input_args.lg is not None:
        leagues = input_args.lg.split(",")
        print(f"Parsed Leagues: {leagues}")
    if input_args.teams is not None:
        teams = input_args.teams.split(",")
        print(f"Parsed Teams: {teams}")
    return start_date, end_date, batch, leagues, teams


def fetch_input_args():
    """
    Parse user input args from the command line into variables.
    """
    parser = argparse.ArgumentParser("simple_example")
    parser.add_argument(
        "--startDate", help="The oldest date to consider, Format: \"'MM/DD/YYYY'\")"
    )
    parser.add_argument(
        "--endDate", help="The most recent date to consider, Format: \"'MM/DD/YYYY'\")"
    )
    parser.add_argument(
        "--batch", help="[WIP], Format: \"5000\")"
    )
    parser.add_argument(
        "--lg",
        help="League names, Format: \"'American League,National League'\")",
    )
    parser.add_argument(
        "--teams", help="Team names, Format: \"'Boston Red Sox,Milwaukee Brewers'\")"
    )
    input_args = parser.parse_args()
    return format_args(input_args=input_args)
