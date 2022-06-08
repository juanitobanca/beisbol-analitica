import argparse
from datetime import (
    datetime as dt,
    timedelta as td
)
import os
import pandas as pd
from sqlalchemy import create_engine as ce

import const as c
from playByPlay import playByPlay
from people     import people
from boxscore   import boxscore
from transactions import transactions
from contextMetrics import contextMetrics
from lookups.helpers import lookupByValue
from lookups.mappings.sport_id_mapping import sport_id_map
from lookups.mappings.league_id_mapping import league_id_map
from lookups.mappings.team_id_mapping import team_id_map


def getSchedule(p_startDate, p_endDate, p_sportId=None, p_leagueId=None, p_teamId=None):

    print("Getting Schedules")

    games = set()
    additional_query = f"startDate={p_startDate}&endDate={p_endDate}"
    additional_query += f"&sportId={p_sportId}" if p_sportId else ""
    additional_query += f"&leagueId={p_leagueId}" if p_leagueId else ""
    additional_query += f"&teamId={p_teamId}" if p_teamId else ""
    schedule = c.parseJson( additional_query, 'schedule' )

    for d in schedule['dates']:
        for g in d['games']:
            games.add(g['gamePk'])

    print('Done getting schedules')

    return list(games)

def initConnection( con ):

    print("Initializing Database Connection")

    return ce( con )

def insertToDatabase( p_data, p_con, p_table ):

    print ( p_table[2:]+": Inserting into database.")

    while True:

        try:

            p_data.to_sql( name      = p_table
                         , con       = p_con
                         , if_exists = "append"
                         , index     = False
                         #, flavor    = 'mysql'
                         )
        except Exception as e:

            print (p_table[2:]+": Some issue inserting into database.")
            print (str(e))
            continue

        break

def toPandas( d ):

    #print('Converting batch to Pandas.')

    p = pd.DataFrame.from_dict( d )

    return p

def scrapeAndInsertData( p_games, p_batch, p_con, p_league ):

    print('Starting scrape and insert for '+str(len(p_games))+' games.')
    ppl_set = set()
    official_set = set()
    tm_set = set()

    play   = playByPlay()
    box    = boxscore()
    ppl    = people()
    cnt    = contextMetrics()
    tr     = transactions()

    for chunk_ in range( 0, len(p_games), p_batch ):
       print('Chunk: '+str(round((chunk_ + p_batch) / p_batch ))+'. Starting logic.' )

       # Set
       box.setData( p_games[ chunk_ : chunk_ + p_batch ] )
       play.setData( p_games[ chunk_ : chunk_ + p_batch ] )
       cnt.setData( p_games[ chunk_ : chunk_ + p_batch ], p_league )

       ppl_set = ppl_set.union( set( box.player_game_info['playerId'] ) )
       official_set  = official_set.union( set( box.official_types['officialId'] ) )

       # Context Metrics
       insertToDatabase( toPandas( cnt.contextMetrics ), p_con, c.s_game_context )

       # Boxscore Info
       insertToDatabase( toPandas( box.info ),  p_con, c.s_box_info )

       # Boxscore Officials
       insertToDatabase( toPandas( box.official_types ),  p_con, c.s_box_officials )


       # Boxscore Team Stats
       insertToDatabase( toPandas( box.team_batting ),  p_con, c.s_box_team_batting )
       insertToDatabase( toPandas( box.team_pitching ), p_con, c.s_box_team_pitching )
       insertToDatabase( toPandas( box.team_fielding ), p_con, c.s_box_team_fielding )

       # Boxscore Player Stats
       insertToDatabase( toPandas( box.player_batting ),   p_con, c.s_box_player_batting )
       insertToDatabase( toPandas( box.player_pitching ),  p_con, c.s_box_player_pitching )
       insertToDatabase( toPandas( box.player_fielding ),  p_con, c.s_box_player_fielding )

       # Boxscore Player General Info
       insertToDatabase( toPandas( box.team_batting_order ),     p_con, c.s_box_team_batting_order )
       insertToDatabase( toPandas( box.team ),                   p_con, c.s_box_team )
       insertToDatabase( toPandas( box.player_game_positions ),  p_con, c.s_box_player_game_positions )
       insertToDatabase( toPandas( box.player_game_info ),       p_con, c.s_box_player_game_info )

       # Play By Play
       insertToDatabase( toPandas( play.atbat ),   p_con, c.s_play_atbat )
       insertToDatabase( toPandas( play.runner ),  p_con, c.s_play_runner )
       insertToDatabase( toPandas( play.credit ),  p_con, c.s_play_credit )
       insertToDatabase( toPandas( play.pitch ),   p_con, c.s_play_pitch )
       insertToDatabase( toPandas( play.action ),  p_con, c.s_play_action )
       insertToDatabase( toPandas( play.pickoff ), p_con, c.s_play_pickoff )

       # People
       ppl.setData( ppl_set )
       insertToDatabase( toPandas( ppl.people ), p_con, c.s_players )

       ppl.setData( official_set )
       insertToDatabase( toPandas( ppl.people ), p_con, c.s_officials )

       # Transactions
       tm_set = set(cnt.contextMetrics['homeId'])
       tr.setData( tm_set, args.startDate, args.endDate )
       insertToDatabase( toPandas( tr.transactions ), p_con, c.s_transactions )


def preview_data(con):
    """
    Print 10 rows for each table in the connection's database.
    """
    list_all_tables = "SELECT name FROM sqlite_master WHERE type='table';"
    print(f"Query: {list_all_tables}")
    tables = pd.read_sql_query(list_all_tables, con)
    print(tables)
    for _, table in tables.iterrows():
        table_name = table["name"]
        preview_table = f" SELECT * FROM {table_name} LIMIT 10;"
        print(f"Query: {preview_table}")
        print(pd.read_sql_query(preview_table, con))


# Default variables
yesterday  = dt.today() - td(1)
today = dt.today() 
start_date = yesterday.strftime("%m/%d/%Y")
end_date  = today.strftime("%m/%d/%Y")

# Argument Parser
parser = argparse.ArgumentParser(usage=f"""
    This script loads game data into a database.
    
    The command below will load yesterdays mlb game data:
        python3 {os.path.relpath(__file__)}

    The flags below are responsible for configuring:
        - what games to load               (ie. team, league, and/or date range)
        - where to store the game data     (ie. local sqlite.db file)
        - how many games to load at a time (ie. 500 games w/ 16 GB of RAM)
""")
parser.add_argument("--con",       help="The database connection to use, Format: --con='sqlite:///" + os.getcwd() + "/my_local.db'", default = f"sqlite:///{os.getcwd()}/my_local.db")
parser.add_argument("--startDate", help="The oldest date to consider, Format: --startDate='MM/DD/YYYY'", default = start_date)
parser.add_argument("--endDate",   help="The most recent date to consider, Format: --endDate='MM/DD/YYYY'", default = end_date)
parser.add_argument("--batch",     help="Games to load per batch, Format: --batch='500'", default = 500, type = int)
parser.add_argument("--lg",        help="League name, Format: --lg='MLB'", default = "MLB")
parser.add_argument("--team",      help="Team name, Format: --team='Boston Red Sox'", default=None)

# Parse Arguments
args = parser.parse_args()

# Initialize Variables
con = initConnection(args.con)
start_date = args.startDate
end_date = args.endDate
batch = args.batch
sport_id = lookupByValue(sport_id_map,args.lg) if args.lg else None
league_id = lookupByValue(league_id_map,args.lg) if args.lg else None
team_id = lookupByValue(team_id_map, args.team) if args.team else None
print(f"League Name: {args.lg}")
print(f"League Id: {sport_id}")
print(f"Team Name: {args.team}")
print(f"Team Id: {team_id}")
print(f"Sport Id: {sport_id}")
print(f"Database: {args.con}")

# Retrieve Game IDs
games = getSchedule(start_date, end_date, sport_id, league_id, team_id)

# Download game data into python object, and load it into DB
scrapeAndInsertData(games, batch, con, league_id)

# Preview tables that were built from game data
preview_data(con)

'''
box.setData( [ '587933' ] )

d = box.team_pitching

play.setData( [ '587933' ] )
d2 = play.atbat
'''
