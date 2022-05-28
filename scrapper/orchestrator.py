import const  as c
import pandas as pd
import argparse
from sqlalchemy import create_engine as ce, types
from playByPlay import playByPlay
from people     import people
from boxscore   import boxscore
from transactions import transactions
from contextMetrics import contextMetrics
from datetime   import datetime as dt, timedelta as td

def getSchedule( p_file, p_date, p_startDate, p_endDate, p_sportId, p_leagueId ):

    print("Getting Schedules")

    games = set()

    # MLB doesn't have a leagueId
    if p_leagueId == 1:
        p_leagueId = ""
    else:
        p_leagueId = f"&leagueId={p_leagueId}"

    # Parse the schedule files
    if p_startDate and p_endDate:
        parsing_arg = f'sportId={p_sportId}{p_leagueId}&startDate={p_startDate}&endDate={p_endDate}'
    elif p_date:
        parsing_arg = f'sportId={p_sportId}{p_leagueId}'

    schedule = c.parseJson( parsing_arg, 'schedule' )

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
date  = dt.today() - td(1)
date  = date.strftime("%Y_%m_%d")

# Argument Parser
parser = argparse.ArgumentParser(description="Whatever")

# Add Arguments
# 10.0.0.243

parser.add_argument("--con",       action="store"  , dest = "con"                                        , default = None)
parser.add_argument("--date",      action = "store", dest = "date",      help = "Date Format: YYYY_MM_DD", default = date)
parser.add_argument("--startDate", action = "store", dest = "startDate", help = "Date Format: YYYY_MM_DD", default = None)
parser.add_argument("--endDate",   action = "store", dest = "endDate",   help = "Date Format: YYYY_MM_DD", default = None)
parser.add_argument("--file",      action = "store", dest = "file"                                       , default = None)
parser.add_argument("--batch",     action = "store", dest = "batch"                                      , default = 500, type = int )
parser.add_argument("--lg",        action = "store", dest = "lg",        help = "Pick aaa or win"        , default = None )


# Parse Arguments
args = parser.parse_args()

# Here we assign the value thats gonna be inerted for major_league_id in the db.
# Kindly look at contextMetrics.py
c.major_league = args.lg
c.major_league_id = c.major_id_dic[ args.lg ]
sportId = c.sports_id_dic[args.lg]

# Create connection
con  = initConnection( args.con )

# Read and filter file
d = getSchedule( args.file, args.date, args.startDate, args.endDate, sportId, c.major_league_id )
scrapeAndInsertData( d, args.batch, con )

'''
box.setData( [ '587933' ] )

d = box.team_pitching

play.setData( [ '587933' ] )
d2 = play.atbat
'''
