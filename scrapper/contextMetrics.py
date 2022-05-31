from operator import le
import const as c

from lookups.mappings.league_id_mapping import league_id_map

class contextMetrics:

    def __init__( self ):
        self.json    = None
        self.game_pk = None
        self.contextMetrics = None

    def setContextMetrics( self, f, s, d ):

        for s_ in s:

            try:
                if f == c.contextGame_flag:
                    v_ = c.defaultMissingValue( self.json['game'], s_, None )

                elif f == c.contextGameStatus_flag:
                    v_ = c.defaultMissingValue( self.json['game']['status'], s_, None )

                elif f == c.contextGameVenue_flag:
                    s__ = s_[5:].lower()
                    v_ = c.defaultMissingValue( self.json['game']['venue'], s__, None )

                elif f == c.contextGameAway_flag or f == c.contextGameHome_flag:

                    s__ = s_[4].lower() + s_[5:]

                    if 'wins' in s__ or 'losses' in s__ or 'pct' in s__:
                        v_ = c.defaultMissingValue( self.json['game']['teams'][f]['leagueRecord'], s__, None )

                    elif 'id' in s__ or 'name' in s__ :
                        v_ = c.defaultMissingValue( self.json['game']['teams'][f]['team'], s__, None )

                    else:
                        v_ = c.defaultMissingValue( self.json['game']['teams'][f], s__, None )

                else:
                    v_ = c.defaultMissingValue( self.json, s_ , None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )


    def setData( self, game_pk, leagues):

        self.contextMetrics = c.createDataset( c.contextGame
                                             + c.contextGameStatus
                                             + c.contextGameAway
                                             + c.contextGameHome
                                             + c.contextGameVenue
                                             , None
                                             )

        for g_ in game_pk:
            self.json    = c.parseJson( g_, c.context_file )

            if not c.jsonIsValid( self.json ):
                continue

            self.setContextMetrics( c.contextGame_flag,       c.contextGame,       self.contextMetrics )
            self.setContextMetrics( c.contextGameStatus_flag, c.contextGameStatus, self.contextMetrics )
            self.setContextMetrics( c.contextGameAway_flag,   c.contextGameAway,   self.contextMetrics )
            self.setContextMetrics( c.contextGameHome_flag,   c.contextGameHome,   self.contextMetrics )
            self.setContextMetrics( c.contextGameVenue_flag,  c.contextGameVenue,  self.contextMetrics )

        self.contextMetrics['majorLeague'] = [league_id_map[leagues[0]]] * len( self.contextMetrics['gamePk'] )
        self.contextMetrics['majorLeagueId'] = [leagues[0]] * len( self.contextMetrics['gamePk'] )


        return self.contextMetrics
