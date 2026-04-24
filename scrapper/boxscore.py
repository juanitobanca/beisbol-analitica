import const as c

class boxscore:

    def __init__( self ):
        self.json                  = None
        self.game_pk               = None
        self.player_batting        = None
        self.player_pitching       = None
        self.player_fielding       = None
        self.team_batting          = None
        self.team_pitching         = None
        self.team_fielding         = None
        self.team_batting_order    = None
        self.team                  = None
        self.player_game_positions = None
        self.player_game_info      = None
        self.info                  = None
        self.official_types        = None

    def setMetadata( self, d, t_, p_ ):

        d['gamePk'].append( self.game_pk )
        d['teamId'].append( self.json['teams'][t_]['team']['id'] )
        d['teamType'].append( t_ )

        if p_:
            d['playerId'].append( self.json['teams'][t_]['players'][p_]['person']['id'] )

    def setOfficialTypes( self, o, d ):

        d['officialId'].append( o['official']['id'] )
        d['position'].append( o['officialType'] )


    def setInfo( self, f, s, d ):

       # Game Info is different from any other scrape since its a list of dictionaries.

        for s_ in s:

            v_ = None

            if f in self.json.keys():

                for i_ in self.json[f]:

                    if ( i_['label'] == 'Weather' and s_ == 'weather' ) or \
                    ( i_['label'] == 'Wind'    and s_ == 'wind' ) or \
                    ( i_['label'] == 'Att'     and s_ == 'attendance' ):

                        v_ = i_['value']

                        break

                d[s_].append( v_ )

            else:

                for s_ in s:
                    d[s_] = None

    def setBattingOrder( self, t_, d ):

        try:
            for b_ in self.json['teams'][t_]['players']:
                self.setMetadata( d, t_, None )
                d['playerId'].append( b_.replace("ID","") )

                if 'battingOrder' in self.json['teams'][t_]['players'][b_]:
                    d['battingOrder'].append( self.json['teams'][t_]['players'][b_]['battingOrder'] )
                else:
                    d['battingOrder'].append(None)

        except Exception as e:
            print(f"got {e}")

    def setTeam( self, t_, f, s, d ):

        for s_ in s:

            try:
                if f == c.box_team_meta2_flag:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['team'], s_, None )
                elif 'Id' in s_:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['team'][f], 'id', None )
                elif 'Name' in s_:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['team'][f], 'name', None )
                elif 'Link' in s_:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['team'][f], 'link', None )
                else:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['teamStats'][f], s_, None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )

    def setPlayer( self, t_, p_, f, s, d ):

        for s_ in s:

            try:
                v_ = c.defaultMissingValue( self.json['teams'][t_]['players'][p_][f], s_, None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )

    def setStats( self, t_, p_, f, s, d ):

        for s_ in s:

            try:
                if  p_:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['players'][p_]['stats'][f], s_, None )

                elif t_:
                    v_ = c.defaultMissingValue( self.json['teams'][t_]['teamStats'][f], s_, None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )

    def _init_datasets( self ):

        self.info = c.createDataset( c.box_info_details
                                   , c.box_info_meta
                                   )

        self.official_types = c.createDataset( c.box_officials_details
                                             , c.box_officials_meta
                                             )

        self.team = c.createDataset( c.box_team_meta2
                                   + c.box_team_league
                                   + c.box_team_venue
                                   + c.box_team_division
                                   , c.box_team_meta
                                   )

        self.team_batting = c.createDataset( c.box_team_batting_stats
                                           , c.box_team_meta
                                           )
        self.team_pitching = c.createDataset( c.box_team_pitching_stats
                                            , c.box_team_meta
                                            )

        self.team_fielding = c.createDataset( c.box_team_fielding_stats
                                            , c.box_team_meta
                                            )

        self.team_batting_order = c.createDataset( c.box_team_batting_order
                                                 , c.box_team_meta
                                                 )

        self.player_batting = c.createDataset( c.box_player_batting_stats
                                             , c.box_player_meta
                                             )

        self.player_pitching = c.createDataset( c.box_player_pitching_stats
                                              , c.box_player_meta
                                              )

        self.player_fielding = c.createDataset( c.box_player_fielding_stats
                                              , c.box_player_meta
                                              )

        self.player_game_info = c.createDataset( c.box_player_player_gameStatus
                                               + c.box_player_player_person
                                               + c.box_player_player_position
                                               , c.box_player_meta
                                               )

        self.player_game_positions = c.createDataset( c.box_player_player_allPositions
                                                    , c.box_player_meta
                                                    )

    def setData( self, game_pks ):

        self._init_datasets()

        for g_ in game_pks:
            self.game_pk = g_
            self.json    = c.parseJson( g_, c.boxscore_file )

            if not c.jsonIsValid( self.json ):
                print("Invalid JSON, skipping.")
                continue

            self.info['gamePk'].append(g_)
            self.setInfo( c.box_info_flag, c.box_info_details, self.info )

            for o in self.json['officials']:
                self.official_types['gamePk'].append(g_)
                self.setOfficialTypes( o , self.official_types)

            for t_ in self.json['teams']:
                self.setMetadata( self.team, t_, None)
                self.setTeam( t_, c.box_team_meta2_flag,    c.box_team_meta2,    self.team )
                self.setTeam( t_, c.box_team_league_flag,   c.box_team_league,   self.team )
                self.setTeam( t_, c.box_team_venue_flag,    c.box_team_venue,    self.team )
                self.setTeam( t_, c.box_team_division_flag, c.box_team_division, self.team )

                self.setMetadata( self.team_batting, t_, None)
                self.setStats( t_, None,  c.box_team_batting_flag,  c.box_team_batting_stats,  self.team_batting )

                self.setMetadata( self.team_pitching, t_, None)
                self.setStats( t_, None,  c.box_team_pitching_flag, c.box_team_pitching_stats, self.team_pitching )

                self.setMetadata( self.team_fielding, t_, None)
                self.setStats( t_, None,  c.box_team_fielding_flag, c.box_team_fielding_stats, self.team_fielding )

                self.setBattingOrder( t_, self.team_batting_order )

                for p_ in self.json['teams'][t_]['players']:
                    self.setMetadata( self.player_batting, t_, p_)
                    self.setMetadata( self.player_pitching, t_, p_)
                    self.setMetadata( self.player_fielding, t_, p_)
                    self.setMetadata( self.player_game_info, t_, p_)

                    self.setStats( t_, p_, c.box_player_batting_flag,  c.box_player_batting_stats,  self.player_batting )
                    self.setStats( t_, p_, c.box_player_pitching_flag, c.box_player_pitching_stats, self.player_pitching )
                    self.setStats( t_, p_, c.box_player_fielding_flag, c.box_player_fielding_stats, self.player_fielding )

                    self.setPlayer( t_, p_, c.box_player_player_gameStatus_flag,  c.box_player_player_gameStatus, self.player_game_info )
                    self.setPlayer( t_, p_, c.box_player_player_person_flag,      c.box_player_player_person,     self.player_game_info )
                    self.setPlayer( t_, p_, c.box_player_player_position_flag,    c.box_player_player_position,   self.player_game_info )

                    # All Positions
                    if 'allPositions' in self.json['teams'][t_]['players'][p_]:
                        for pp_ in self.json['teams'][t_]['players'][p_]['allPositions']:
                            self.setMetadata( self.player_game_positions, t_, p_)
                            for l_ in c.box_player_player_allPositions:
                                self.player_game_positions[l_].append( pp_[l_] )
