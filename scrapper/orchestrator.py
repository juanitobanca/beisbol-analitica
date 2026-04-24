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
    b = boxscore()
    b.setData( [game_pk] )

    p = playByPlay()
    p.setData( [game_pk] )

    cm = contextMetrics()
    cm.setData( [game_pk], major_league, major_league_id )

    return b, p, cm

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

def scrapeAndInsertData( p_games, p_batch, p_con, start_date, end_date, major_league, major_league_id, max_workers=10 ):

    print('Starting scrape and insert for '+str(len(p_games))+' games.')

    # Sets acumulados a lo largo de todos los chunks — solo para tracking,
    # nunca se pasan directamente a setData.
    seen_ppl      = set()
    seen_officials = set()

    ppl    = people()
    tr     = transactions()

    for chunk_ in range( 0, len(p_games), p_batch ):
       chunk_games = p_games[ chunk_ : chunk_ + p_batch ]
       print('Chunk: '+str(round((chunk_ + p_batch) / p_batch ))+'. Starting logic.' )

       # Crear instancias vacías que recibirán los resultados fusionados
       box = boxscore()
       box._init_datasets()
       play = playByPlay()
       play._init_datasets()
       cnt = contextMetrics()
       cnt._init_datasets()

       # Descargar todos los juegos del chunk en paralelo.
       # Cada worker opera sobre su propia instancia — sin estado compartido.
       with ThreadPoolExecutor(max_workers=max_workers) as pool:
           futures = { pool.submit(_fetch_game, gk, major_league, major_league_id): gk for gk in chunk_games }
           for future in as_completed(futures):
               gk = futures[future]
               try:
                   b, p, cm = future.result()
               except Exception as e:
                   print(f"Game {gk} failed: {e}")
                   continue

               # Fusionar resultados en los acumuladores del chunk
               for attr in ('info','official_types','team','team_batting','team_pitching',
                            'team_fielding','team_batting_order','player_batting',
                            'player_pitching','player_fielding','player_game_info',
                            'player_game_positions'):
                   _merge_dicts( getattr(box, attr), getattr(b, attr) )

               for attr in ('atbat','runner','credit','pitch','action','pickoff'):
                   _merge_dicts( getattr(play, attr), getattr(p, attr) )

               _merge_dicts( cnt.contextMetrics, cm.contextMetrics )

       # IDs vistos en este chunk
       chunk_ppl      = set( box.player_game_info['playerId'] )
       chunk_officials = set( box.official_types['officialId'] )

       # Solo fetchear los IDs que no se procesaron en chunks anteriores
       new_ppl       = chunk_ppl      - seen_ppl
       new_officials = chunk_officials - seen_officials

       # Actualizar el tracking global
       seen_ppl      |= chunk_ppl
       seen_officials |= chunk_officials

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

       # People — solo IDs nuevos, nunca los ya insertados en chunks anteriores
       ppl.setData( new_ppl )
       insertToDatabase( toPandas( ppl.people ), p_con, c.s_players )

       ppl.setData( new_officials )
       insertToDatabase( toPandas( ppl.people ), p_con, c.s_officials )

       # Transactions
       tm_set = set(cnt.contextMetrics['homeId'])
       tr.setData( tm_set, start_date, end_date )
       insertToDatabase( toPandas( tr.transactions ), p_con, c.s_transactions )


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
    major_league_id = c.major_id_dic[ args.lg ]
    sportId         = c.sports_id_dic[ args.lg ]

    # Create connection
    con = initConnection( args.con )

    # Read and filter file
    d = getSchedule( args.file, args.date, args.startDate, args.endDate, sportId, major_league_id )
    scrapeAndInsertData( d, args.batch, con, args.startDate, args.endDate, major_league, major_league_id, max_workers=args.workers )
