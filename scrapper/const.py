import requests as r
import logging
import datetime

def writeToCSV( d, file_name):
    print('Writing to CSV...')
    d.to_csv( file_name, sep = ',')

def createDataset( s, m ):

    d = {}

    for s_ in s:
        d[s_] = []

    if m:

        for m_ in m:
            d[m_] = []

    return d

def defaultMissingValue( d, k, v ):

    if not d:
        return None

    if k in d.keys():
        return d[k]

    return None

def parseJson( parsing_arg, file ):

    if file == people_file:
        url = 'http://statsapi.mlb.com/api/v1/people/' + str(int(parsing_arg))
        print('Player: '+str(int(parsing_arg))+'. Parsing '+file+'.')

    elif file == transactions_file:
        url = 'http://statsapi.mlb.com/api/v1/transactions?' + parsing_arg
        print('Team: '+parsing_arg+'. Parsing '+file+'.')

    elif file == schedule_file:
        url = 'http://statsapi.mlb.com/api/v1/schedule?'+ parsing_arg
        print('Schedule: '+parsing_arg+'. Parsing '+file+'.')
    else:
        url = 'http://statsapi.mlb.com/api/v1/game/' + str(int(parsing_arg)) + '/' + file
        print('Game: '+str(int(parsing_arg))+'. Parsing '+file+'.')

    print(url)

    while True:

        try:
            req = r.get(url)
            return req.json()
        except Exception as e:
            print(f"Error parsing game {str(int(parsing_arg))}, file {file}: {e}")
            continue

def jsonIsValid( json ):

    if 'message' in json.keys() and ( json['message'] == "Comparison method violates its general contract!" or json['messageNumber'] in [1, 13] ):
        return False

    elif not json.keys():
        return False

    return True

#
#
# LOGGING
#
#
#logging.basicConfig( filename = 'baseball '+str(datetime.datetime.now())+'.log', level = print )

# LEAGUE - this is what gets inserted into the db
# Example: https://statsapi.mlb.com/api/v1/gamePace?leagueIds=125&startDate=2019-07-28&endDate=2019-10-30

sports_id_dic = { 'MLB' : 1
                , 'LMB':  11 # 23
                , 'DSL' : 16
                , 'LIDOM': 17
                , 'LMP': 17
                , 'LBPRC': 17
                , 'VSL' : 17
                , 'LVBP': 17
                , 'SDC' : 17
                , 'WBCQ': 51
                , 'WBC' : 51
                }

major_id_dic = { 'MLB': 1
               , 'LMB': 125
               , 'DSL' : 130
               , 'LIDOM': 131
               , 'LMP': 132
               , 'LBPRC': 133
               , 'VSL' : 134
               , 'LVBP': 135
               , 'WBCQ': 159
               , 'WBC' : 160
               , 'SDC' : 162
               }


major_league = None
major_league_id = None


# STAGING TABLE CONSTANTS

# TRANSACTIONS
s_transactions = 'stg_transactions'

# CONTEXT METRICS
s_game_context = 'stg_game_context'

# BOXSCORE

s_box_team_batting  = 'stg_box_team_batting'
s_box_team_pitching = 'stg_box_team_pitching'
s_box_team_fielding = 'stg_box_team_fielding'

s_box_player_batting  = 'stg_box_player_batting'
s_box_player_pitching = 'stg_box_player_pitching'
s_box_player_fielding = 'stg_box_player_fielding'

s_players              = 'stg_players'
s_officials            = 'stg_officials'


s_box_team_batting_order    = 'stg_box_team_batting_order'
s_box_team                  = 'stg_box_team'
s_box_player_game_positions = 'stg_box_player_game_positions'
s_box_player_game_info      = 'stg_box_player_game_info'
s_box_info                  = 'stg_box_info'
s_box_officials             = 'stg_box_officials'


#PLAY BY PLAY
s_play_atbat    = 'stg_play_atbat'
s_play_runner   = 'stg_play_runner'
s_play_credit   = 'stg_play_credit'
s_play_pitch    = 'stg_play_pitch'
s_play_action   = 'stg_play_action'
s_play_pickoff  = 'stg_play_pickoff'


#
# FILES FOR URL
#
playByPlay_file = 'playByPlay'
boxscore_file   = 'boxscore'
people_file     = 'people'
context_file    = 'contextMetrics'
schedule_file   = 'schedule'
transactions_file = 'transactions'

#
# GAME CONSTANTS
#
#
#

contextGame_flag       = 'game'
contextGameStatus_flag = 'status'
contextGameAway_flag   = 'away'
contextGameHome_flag   = 'home'
contextGameVenue_flag  = 'venue'
contextGameMeta_flag   = 'meta'

contextGame       = ['gamePk', 'gameType', 'season','gameDate', 'isTie', 'gameNumber', 'publicFacing', 'doubleHeader', 'gamedayType', 'tiebreaker', 'calendarEventID'
                    , 'seasonDisplay', 'dayNight', 'description', 'scheduledInnings', 'gamesInSeries', 'seriesGameNumber'
                    , 'seriesDescription', 'recordSource', 'ifNecessary', 'ifNecessaryDescription', 'gameId']
contextGameStatus = ['abstractGameState', 'codedGameState', 'detailedState', 'statusCode', 'abstractGameCode']
contextGameAway   = ['awayWins','awayLosses','awayPct', 'awayScore', 'awayId', 'awayName', 'awayIsWinner']
contextGameHome   = ['homeWins','homeLosses','homePct', 'homeScore', 'homeId', 'homeName', 'homeIsWinner']
contextGameVenue  = ['venueId', 'venueName', 'venueLink']


#
#   PEOPLE(PLAYERS) CONSTANTS
#
#
#
people_meta = [ 'id','fullName','link','firstName','lastName','birthDate','currentAge','birthCity','birthStateProvince'
              ,'birthCountry','height','weight','active','useName','middleName','boxscoreName','nameFirstLast','nameSlug'
              ,'firstLastName','lastFirstName','lastInitName','initLastName','fullFMLName','fullLFMName','strikeZoneTop'
              ,'strikeZoneBottom'
              ]

people_primaryPosition  = ['abbreviation']
people_batSide          = ['batSideCode']
people_pitchHand        = ['pitchHandCode']

people_meta_flag             = 'meta'
people_primaryPosition_flag  = 'primaryPosition'
people_batSide_flag          = 'batSide'
people_pitchHand_flag        = 'pitchHand'

#
#   TRANSACTION CONSTANTS
#
#
#
transactions_meta = [ 'id',  'transactionDate', 'effectiveDate', 'resolutionDate', 'typeCode', 'typeDesc', 'description' ]
transactions_personId = ['personId']
transactions_toTeamId = ['toTeamId']
transactions_teamId = ['teamId']
transactions_meta_flag = 'meta'
transactions_person_flag = 'person'
transactions_toTeam_flag = 'toTeam'

#
#   PLAY BY PLAYS CONSTANTS
#
#
#

# ATBAT= ABOUT + RESULT + COUNT + MATCHUP

play_atbat_meta = ['gamePk']

#  ABOUT, RESULT AND COUNT
play_about_flag  = 'about'
play_result_flag = 'result'
play_count_flag  = 'count'

play_about   = ['atBatIndex','captivatingIndex','endTime','halfInning','hasOut','hasReview','inning', 'isComplete', 'isScoringPlay', 'startTime']
play_result  = ['awayScore','description','event','eventType','homeScore','rbi','type']
play_count   = ['balls','outs','strikes']

# MATCHUP

play_matchup_batside_flag   = 'batSide'
play_matchup_pitchhand_flag = 'pitchHand'
play_matchup_batter_flag    = 'batter'
play_matchup_pitcher_flag   = 'pitcher'
play_matchup_splits_flag    = 'splits'


play_matchup_batside   = ['batterSideCode', 'batterSideDescription']
play_matchup_pitchhand = ['pitcherHandCode', 'pitcherHandDescription']
play_matchup_batter    = ['batterId']
play_matchup_pitcher   = ['pitcherId']
play_matchup_splits    = ['menOnBase']

# RUNNER
play_runner_meta = ['gamePk','atBatIndex']

play_runner_movement_flag = 'movement'
play_runner_details_flag  = 'details'

play_runner_movement = ['endBase','isOut','outBase','outNumber','startBase']
play_runner_details  = ['earned','event','eventType','isScoringEvent','movementReason','playIndex','rbi','responsiblePitcherId','teamUnearned', 'runnerId']

# CREDITS
play_credit_meta = ['gamePk','atBatIndex']

play_credit_credit_flag   = 'credit'
play_credit_player_flag   = 'player'
play_credit_position_flag = 'position'

play_credit_credit   = ['credit']
play_credit_player   = ['playerId']
play_credit_position = ['abbreviation', 'code', 'name', 'type' ]

# PITCH EVENTS
pitch_meta2_flag        = 'meta'
pitch_details_flag      = 'details'
pitch_count_flag        = 'count'
pitch_data_flag         = 'pitchData'
pitch_data_coord_flag   = 'coordinates'
pitch_data_breaks_flag  = 'breaks'
pitch_hit_data_flag     = 'hitData'
pitch_hit_data_coord_flag = 'hit_coordinates'

pitch_meta    = [ 'atBatIndex', 'gamePk' ]
pitch_meta2   = [ 'index','pfxId','playId','pitchNumber','startTime','endTime','isPitch','type' ]
pitch_details = [ 'callCode', 'callDescription', 'description', 'code'
                , 'ballColor', 'trailColor', 'isInPlay', 'isStrike', 'isBall', 'typeCode', 'typeDescription', 'hasReview'
                , 'runnerGoing']
pitch_count   = [ 'balls', 'strikes' ]
pitch_data    = [ 'startSpeed', 'endSpeed', 'strikeZoneTop', 'strikeZoneBottom' ]
pitch_data_coord = ['aY', 'aZ' , 'pfxX' , 'pfxZ' , 'pX' ,'pZ' ,'vX0' ,'vY0' ,'vZ0' ,'x' ,'y' ,'x0' ,'y0' ,'z0' ,'aX', 'zone','typeConfidence']
pitch_data_breaks  = [ 'breakAngle' ,'breakLength' ,'breakY' ,'spinRate' ,'spinDirection']
pitch_hit_data = ['launchSpeed','launchAngle','totalDistance','trajectory','hardness','location']
pitch_hit_data_coord = ['coordX', 'coordY']

# ACTION EVENTS
action_meta2_flag    = 'meta'
action_details_flag  = 'details'
action_count_flag    = 'count'
action_player_flag   = 'player'
action_position_flag = 'position'

action_meta    = [ 'atBatIndex', 'gamePk' ]
action_meta2   = [ 'index', 'startTime', 'endTime', 'isPitch', 'type', 'battingOrder', 'injuryType' ]
action_details = [ 'description', 'event', 'awayScore', 'homeScore', 'isScoringPlay', 'hasReview','eventType']
action_count   = [ 'balls', 'strikes', 'outs' ]
action_player  = ['playerId']
action_position = ['abbreviation', 'code', 'name' ]

# PICKOFF EVENTS
pickoff_meta2_flag    = 'meta'
pickoff_details_flag  = 'details'
pickoff_count_flag    = 'count'

pickoff_meta    = [ 'atBatIndex', 'gamePk' ]
pickoff_meta2   = [ 'index', 'playId', 'isPitch' ]
pickoff_details = [ 'description', 'code', 'hasReview', 'fromCatcher' ]
pickoff_count   = [ 'balls', 'strikes', 'outs' ]



#
#   BOXSCORE CONSTANTS
#
#
#

#   GAME INFO
box_info_meta    = [ 'gamePk' ]
box_info_flag    = 'info'
box_info_details = [ 'weather', 'wind', 'attendance']

#   OFFICIALS
box_officials_meta    = [ 'gamePk' ]
box_officials_flag    = 'officials'
box_officials_details = [ 'officialId',  'position']


#   PLAYER

box_player_meta = [ 'gamePk' , 'teamId', 'teamType' , 'playerId']

box_player_batting_flag  = 'batting'
box_player_pitching_flag = 'pitching'
box_player_fielding_flag = 'fielding'

box_player_meta2 = [ 'link', 'fullName']

box_player_position = [ 'code', 'name', 'type', 'abbreviation' ]

box_player_batting_stats = [ 'atBats','baseOnBalls','catchersInterference','caughtStealing','doubles','flyOuts'
                           ,  'groundIntoDoublePlay','groundIntoTriplePlay','groundOuts','hitByPitch','hits','homeRuns'
                           ,  'intentionalWalks','leftOnBase','pickoffs','rbi','runs','sacBunts'
                           , 'sacFlies','stolenBases','strikeOuts','totalBases','triples'
                           ]



box_player_pitching_stats =  [ 'airOuts','atBats','balls','baseOnBalls','battersFaced','blownSaves','catchersInterference'
                             , 'caughtStealing','completeGames','doubles','earnedRuns','gamesFinished','gamesPitched','gamesPlayed'
                             , 'gamesStarted','groundOuts','hitBatsmen','hits','holds','homeRuns','inheritedRunners'
                             , 'inheritedRunnersScored','intentionalWalks','losses','numberOfPitches','outs'
                             , 'pickoffs','pitchesThrown','rbi','runs','sacBunts','sacFlies','saveOpportunities'
                             , 'saves','shutouts','stolenBases','strikeOuts','strikes','triples','wildPitches','wins'
                             ]

box_player_fielding_stats =  [ 'assists','caughtStealing','chances','errors','passedBall'
                             , 'pickoffs','putOuts','stolenBases'
                             ]

# PLAYER DATA INSIDE PLAYER

box_player_player_gameStatus_flag = 'gameStatus'
box_player_player_person_flag     = 'person'
box_player_player_position_flag   = 'position'

box_player_player_gameStatus = [ 'isSubstitute', 'isOnBench','isCurrentPitcher','isCurrentBatter' ]
box_player_player_person     = [ 'fullName',  'link' ]
box_player_player_position   = [ 'abbreviation', 'code', 'name', 'type' ]

# PLAYER  ALL POSITIONS
box_player_player_allPositions_flag = 'allPositions'
box_player_player_allPositions = [ 'code', 'name', 'type', 'abbreviation' ]

#   TEAM

box_team_meta = [ 'gamePk', 'teamId', 'teamType' ]

box_team_meta2_flag    = 'meta'
box_team_batting_flag  = 'batting'
box_team_pitching_flag = 'pitching'
box_team_fielding_flag = 'fielding'
box_team_venue_flag    = 'venue'
box_team_league_flag   = 'league'
box_team_division_flag = 'division'

#   TEAMS
box_team_meta2 = [ 'abbreviation','active','allStarStatus','fileCode','firstYearOfPlay'
                 , 'locationName','parentOrgId','parentOrgName','season','shortName'
                 , 'teamCode','teamName', 'id', 'name', 'link'
                 ]

box_team_venue = ['venueId', 'venueName', 'venueLink' ]
box_team_league = ['leagueId', 'leagueName', 'leagueLink' ]
box_team_division = ['divisionId', 'divisionName', 'divisionLink']

box_team_batting_stats =  [ 'atBats','baseOnBalls','catchersInterference','caughtStealing','doubles','flyOuts'
                          , 'groundIntoDoublePlay','groundIntoTriplePlay','groundOuts','hitByPitch','hits','homeRuns'
                          , 'intentionalWalks','leftOnBase','pickoffs','rbi','runs','sacBunts'
                          , 'sacFlies', 'stolenBases','strikeOuts','totalBases','triples'
                          ]

box_team_fielding_stats = [ 'assists', 'caughtStealing', 'chances', 'errors', 'passedBall', 'pickoffs'
                          , 'putOuts', 'stolenBases'
                          ]

box_team_pitching_stats = [ 'airOuts','atBats','baseOnBalls','battersFaced','catchersInterference','caughtStealing','completeGames'
                          ,'doubles','earnedRuns', 'groundOuts','hitBatsmen','hits','homeRuns','inheritedRunners','inheritedRunnersScored'
                          , 'intentionalWalks','outs','pickoffs','rbi','runs','sacBunts','sacFlies','saveOpportunities'
                          ,'shutouts','stolenBases','strikeOuts','triples', 'wildPitches'
                          ]

#   BATTING ORDER
box_team_batting_order = { 'gamePk'  : []
                         , 'teamId'  : []
                         , 'playerId': []
                         , 'teamType': []
                         , 'battingOrder': []
                         }
