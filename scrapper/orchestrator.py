from tracemalloc import start
import const  as c
import pandas as pd
import argparse
from sqlalchemy import create_engine as ce, types
from pprint import pprint

from lookups.helpers import lookupByValue
from lookups.mappings.sport_id_mapping import sport_id_map
from lookups.mappings.league_id_mapping import league_id_map
from lookups.mappings.team_id_mapping import team_id_map
    
from playByPlay import playByPlay
from people     import people
from boxscore   import boxscore
from transactions import transactions
from contextMetrics import contextMetrics
from datetime   import datetime as dt, timedelta as td

def getSchedule(p_startDate, p_endDate, p_sportId, p_leagueId=None, p_teamId=None):

    print("Getting Schedules")

    games = set()
    additional_query = f"sportId={p_sportId}&startDate={p_startDate}&endDate={p_endDate}"
    if p_leagueId:
        additional_query += f"&leagueId={p_leagueId}"
    if p_teamId:
        additional_query += f"&teamId={p_teamId}"

    schedule = c.parseJson( additional_query, 'schedule' )
    pprint(schedule)

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

def scrapeAndInsertData( p_games, p_batch, p_con ):

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
       cnt.setData( p_games[ chunk_ : chunk_ + p_batch ] )

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


# Default variables
start_time  = dt.today() - td(1)
start_date = start_time.strftime("%m/%d/%Y")
end_time = dt.today() 
end_date  = end_time.strftime("%m/%d/%Y")

# Argument Parser
parser = argparse.ArgumentParser(description="Parses details about what game data to load.")
parser.add_argument("--conn",      action="store"  , dest = "conn", help="The database connection to use, Format: \"'sqlite://\")", default = "sqlite://")
parser.add_argument("--startDate", action = "store", dest = "startDate", help="The oldest date to consider, Format: \"'MM/DD/YYYY'\")", default = start_date)
parser.add_argument("--endDate",   action = "store", dest = "endDate", help="The most recent date to consider, Format: \"'MM/DD/YYYY'\")", default = end_date)
parser.add_argument("--batch",     action = "store", dest = "batch", help="[WIP], Format: \"5000\")", default = 500, type = int)
parser.add_argument("--lg",        action = "store", dest = "lg", help="League names, Format: \"'MLB,SDC'\")", default = "MLB")
parser.add_argument("--teams",     action = "store", dest = "teams", help="Team names, Format: \"'Boston Red Sox,Milwaukee Brewers'\")", default=None)

# Parse Arguments
args = parser.parse_args()

# Initialize Variables
conn = initConnection(args.conn)
start_date = args.startDate
end_date = args.endDate
batch = args.batch
sport_names = lookupByValue(sport_id_map, args.lg)
league_names = lookupByValue(league_id_map, args.lg)
team_names = lookupByValue(team_id_map, args.teams)

# Retrieve Game IDs
games = getSchedule(start_date, end_date, sport_names, league_names, team_names)

# Download game data into python object, and load it into DB
scrapeAndInsertData(games, batch, conn)

'''
box.setData( [ '587933' ] )

d = box.team_pitching

play.setData( [ '587933' ] )
d2 = play.atbat
'''
