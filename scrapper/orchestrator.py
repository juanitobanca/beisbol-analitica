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
from concurrent.futures import ThreadPoolExecutor, as_completed

def _merge_dicts( base, incoming ):
    """Fusiona 'incoming' en 'base' extendiendo cada lista. Ambos dicts tienen las mismas keys."""
    for key in base:
        base[key].extend( incoming[key] )

def _fetch_game( game_pk, major_league, major_league_id ):
    """
    Descarga y parsea los 3 endpoints de un juego usando instancias locales al thread.

    Cada thread crea sus propios objetos boxscore/playByPlay/contextMetrics, por lo que
    no hay estado compartido mutable — es thread-safe sin necesidad de locks.
    La Session de requests en const._session sí es compartida, pero requests.Session
    es thread-safe para lecturas concurrentes.
    """
    box = boxscore()
    box.setData( [game_pk] )

    play = playByPlay()
    play.setData( [game_pk] )

    ctx = contextMetrics()
    ctx.setData( [game_pk], major_league, major_league_id )

    return box, play, ctx

def getSchedule( file, date, start_date, end_date, sport_id, league_id ):

    print("Getting Schedules")

    games = set()

    # MLB doesn't have a leagueId
    if league_id == 1:
        league_id = ""
    else:
        league_id = f"&leagueId={league_id}"

    # Parse the schedule files
    if start_date and end_date:
        parsing_arg = f'sportId={sport_id}{league_id}&startDate={start_date}&endDate={end_date}'
    elif date:
        parsing_arg = f'sportId={sport_id}{league_id}'

    schedule = c.parseJson( parsing_arg, 'schedule' )

    for d in schedule['dates']:
        for g in d['games']:
            games.add(g['gamePk'])

    print('Done getting schedules')

    return list(games)

def initConnection( con ):

    print("Initializing Database Connection")

    return ce( con )

def insertToDatabase( dataframe, engine, table_name ):

    print ( table_name[2:]+": Inserting into database.")

    while True:

        try:

            dataframe.to_sql( name      = table_name
                         , con       = engine
                         , if_exists = "append"
                         , index     = False
                         )
        except Exception as e:

            print (table_name[2:]+": Some issue inserting into database.")
            print (str(e))
            continue

        break

def toPandas( data ):

    #print('Converting batch to Pandas.')

    df = pd.DataFrame.from_dict( data )

    return df

def scrapeAndInsertData( game_pks, batch_size, engine, start_date, end_date, major_league, major_league_id, max_workers=10 ):

    print('Starting scrape and insert for '+str(len(game_pks))+' games.')

    # Sets acumulados a lo largo de todos los chunks — solo para tracking,
    # nunca se pasan directamente a setData.
    seen_ppl      = set()
    seen_officials = set()

    people_scraper    = people()
    transaction_scraper     = transactions()

    for chunk_start in range( 0, len(game_pks), batch_size ):
       chunk_games = game_pks[ chunk_start : chunk_start + batch_size ]
       print('Chunk: '+str(round((chunk_start + batch_size) / batch_size ))+'. Starting logic.' )

       # Crear instancias vacías que recibirán los resultados fusionados
       box_acc = boxscore()
       box_acc._init_datasets()
       play_acc = playByPlay()
       play_acc._init_datasets()
       cnt = contextMetrics()
       cnt._init_datasets()

       # Descargar todos los juegos del chunk en paralelo.
       # Cada worker opera sobre su propia instancia — sin estado compartido.
       with ThreadPoolExecutor(max_workers=max_workers) as pool:
           futures = { pool.submit(_fetch_game, gk, major_league, major_league_id): gk for gk in chunk_games }
           for future in as_completed(futures):
               gk = futures[future]
               try:
                   fetched_box, fetched_play, fetched_ctx = future.result()
               except Exception as e:
                   print(f"Game {gk} failed: {e}")
                   continue

               # Fusionar resultados en los acumuladores del chunk
               for attr in ('info','official_types','team','team_batting','team_pitching',
                            'team_fielding','team_batting_order','player_batting',
                            'player_pitching','player_fielding','player_game_info',
                            'player_game_positions'):
                   _merge_dicts( getattr(box_acc, attr), getattr(fetched_box, attr) )

               for attr in ('atbat','runner','credit','pitch','action','pickoff'):
                   _merge_dicts( getattr(play_acc, attr), getattr(fetched_play, attr) )

               _merge_dicts( cnt.contextMetrics, fetched_ctx.contextMetrics )

       # IDs vistos en este chunk
       chunk_ppl      = set( box_acc.player_game_info['playerId'] )
       chunk_officials = set( box_acc.official_types['officialId'] )

       # Solo fetchear los IDs que no se procesaron en chunks anteriores
       new_ppl       = chunk_ppl      - seen_ppl
       new_officials = chunk_officials - seen_officials

       # Actualizar el tracking global
       seen_ppl      |= chunk_ppl
       seen_officials |= chunk_officials

       # Context Metrics
       insertToDatabase( toPandas( cnt.contextMetrics ), engine, c.STG_GAME_CONTEXT )

       # Boxscore Info
       insertToDatabase( toPandas( box_acc.info ),  engine, c.STG_BOX_INFO )

       # Boxscore Officials
       insertToDatabase( toPandas( box_acc.official_types ),  engine, c.STG_BOX_OFFICIALS )


       # Boxscore Team Stats
       insertToDatabase( toPandas( box_acc.team_batting ),  engine, c.STG_BOX_TEAM_BATTING )
       insertToDatabase( toPandas( box_acc.team_pitching ), engine, c.STG_BOX_TEAM_PITCHING )
       insertToDatabase( toPandas( box_acc.team_fielding ), engine, c.STG_BOX_TEAM_FIELDING )

       # Boxscore Player Stats
       insertToDatabase( toPandas( box_acc.player_batting ),   engine, c.STG_BOX_PLAYER_BATTING )
       insertToDatabase( toPandas( box_acc.player_pitching ),  engine, c.STG_BOX_PLAYER_PITCHING )
       insertToDatabase( toPandas( box_acc.player_fielding ),  engine, c.STG_BOX_PLAYER_FIELDING )

       # Boxscore Player General Info
       insertToDatabase( toPandas( box_acc.team_batting_order ),     engine, c.STG_BOX_TEAM_BATTING_ORDER )
       insertToDatabase( toPandas( box_acc.team ),                   engine, c.STG_BOX_TEAM )
       insertToDatabase( toPandas( box_acc.player_game_positions ),  engine, c.STG_BOX_PLAYER_GAME_POSITIONS )
       insertToDatabase( toPandas( box_acc.player_game_info ),       engine, c.STG_BOX_PLAYER_GAME_INFO )

       # Play By Play
       insertToDatabase( toPandas( play_acc.atbat ),   engine, c.STG_PLAY_ATBAT )
       insertToDatabase( toPandas( play_acc.runner ),  engine, c.STG_PLAY_RUNNER )
       insertToDatabase( toPandas( play_acc.credit ),  engine, c.STG_PLAY_CREDIT )
       insertToDatabase( toPandas( play_acc.pitch ),   engine, c.STG_PLAY_PITCH )
       insertToDatabase( toPandas( play_acc.action ),  engine, c.STG_PLAY_ACTION )
       insertToDatabase( toPandas( play_acc.pickoff ), engine, c.STG_PLAY_PICKOFF )

       # People — solo IDs nuevos, nunca los ya insertados en chunks anteriores
       people_scraper.setData( new_ppl )
       insertToDatabase( toPandas( people_scraper.people ), engine, c.STG_PLAYERS )

       people_scraper.setData( new_officials )
       insertToDatabase( toPandas( people_scraper.people ), engine, c.STG_OFFICIALS )

       # Transactions
       tm_set = set(cnt.contextMetrics['homeId'])
       transaction_scraper.setData( tm_set, start_date, end_date )
       insertToDatabase( toPandas( transaction_scraper.transactions ), engine, c.STG_TRANSACTIONS )


if __name__ == '__main__':

    # Default variables
    date  = dt.today() - td(1)
    date  = date.strftime("%Y_%m_%d")

    # Argument Parser
    parser = argparse.ArgumentParser(description="Whatever")

    # Add Arguments
    parser.add_argument("--con",       action="store"  , dest = "con"                                        , default = "sqlite:///baseball.db")
    parser.add_argument("--date",      action = "store", dest = "date",      help = "Date Format: YYYY_MM_DD", default = date)
    parser.add_argument("--startDate", action = "store", dest = "startDate", help = "Date Format: YYYY_MM_DD", default = None)
    parser.add_argument("--endDate",   action = "store", dest = "endDate",   help = "Date Format: YYYY_MM_DD", default = None)
    parser.add_argument("--file",      action = "store", dest = "file"                                       , default = None)
    parser.add_argument("--batch",     action = "store", dest = "batch"                                      , default = 500, type = int )
    parser.add_argument("--lg",        action = "store", dest = "lg",        help = "Pick aaa or win"        , default = None )
    parser.add_argument("--workers",   action = "store", dest = "workers",   help = "Threads concurrentes"   , default = 10,  type = int )

    # Parse Arguments
    args = parser.parse_args()

    major_league    = args.lg
    major_league_id = c.LEAGUE_ID[ args.lg ]
    sportId         = c.SPORT_ID[ args.lg ]

    # Create connection
    con = initConnection( args.con )

    # Read and filter file
    d = getSchedule( args.file, args.date, args.startDate, args.endDate, sportId, major_league_id )
    scrapeAndInsertData( d, args.batch, con, args.startDate, args.endDate, major_league, major_league_id, max_workers=args.workers )
