import const as c

class playByPlay:

    def __init__( self ):
        self.json      = None
        self.atbat     = None
        self.runner    = None
        self.credit    = None
        self.pitch     = None
        self.action    = None
        self.pickoff   = None

    def setAboutResultCount( self, a_, f, s, d ):

       for s_ in s:
           v_ = c.defaultMissingValue( a_[f], s_,  None )
           d[s_].append( v_ )

    def setMatchup( self, a_, f, s, d ):

        for s_ in s:

            try:
                if  s_ == 'pitcherHandCode' or s_ == 'batterSideCode':
                    v_ = c.defaultMissingValue( a_['matchup'][f], 'code',  None )

                elif s_ == 'pitcherHandDescription' or s_ == 'batterSideDescription':
                    v_ = c.defaultMissingValue( a_['matchup'][f], 'description',  None )

                elif s_ == 'batterId' or s_ == 'pitcherId':
                    v_ = c.defaultMissingValue( a_['matchup'][f], 'id',  None )

                elif s_ == 'menOnBase':
                    v_ = c.defaultMissingValue( a_['matchup'][f], s_, None)

            except KeyError:
                v_ = None

            d[s_].append( v_ )

    def setRunner( self, r_, f, s, d ):

        # Revisar runner id
        for s_ in s:

            try:
                if s_ == 'runnerId':
                    v_ = c.defaultMissingValue( r_['details']['runner'], 'id',  None )
                elif s_ == 'responsiblePitcherId':
                    v_ = c.defaultMissingValue( r_['details']['responsiblePitcher'], 'id',  None )
                elif s_ == 'endBase':
                    v_ = c.defaultMissingValue( r_[f], 'end',  None )
                elif s_ == 'startBase':
                    v_ = c.defaultMissingValue( r_[f], 'start',  None )
                else:
                    v_ = c.defaultMissingValue( r_[f], s_,  None )

            except KeyError:
                v_ = None

            d[s_].append( v_)

    def setCredit( self, c_, f, s, d ):

        for s_ in s:

            try:
                if  f == c.play_credit_credit_flag:
                    v_ = c.defaultMissingValue( c_, s_,  None )
                elif f == c.play_credit_player_flag:
                    v_ = c.defaultMissingValue( c_[f], 'id',  None )
                else:
                    v_ = c.defaultMissingValue( c_[f], s_,  None )

            except KeyError:
                v_ = None

            d[s_].append( v_)

    def setPitch( self, p_, f, s, d ):

        for s_ in s:

            try:
                # Descriptions
                if   f  == c.pitch_meta2_flag:
                    v_ = c.defaultMissingValue( p_, s_,  None )
                elif s_ == 'callCode':
                    v_ = c.defaultMissingValue( p_[f]['call'], 'code',  None )
                elif s_ == 'callDescription':
                    v_ = c.defaultMissingValue( p_[f]['call'], 'description',  None )
                elif s_ == 'typeCode' and 'type' in p_[f]:
                    v_ = c.defaultMissingValue( p_[f]['type'], 'code',  None )
                elif s_ == 'typeDescription' and 'type' in p_[f]:
                    v_ = c.defaultMissingValue( p_[f]['type'], 'description',  None )
                # Pitch Data
                elif f in [ c.pitch_data_coord_flag, c.pitch_data_breaks_flag ]:
                    v_ = c.defaultMissingValue( p_['pitchData'][f], s_,  None )
                # Hit Data
                elif f == c.pitch_hit_data_flag:
                    if 'hitData' in p_:
                        v_ = c.defaultMissingValue( p_['hitData'], s_,  None )
                    else:
                        v_ = None
                elif f == c.pitch_hit_data_coord_flag:
                    if 'hitData' in p_:
                        v_ = c.defaultMissingValue( p_['hitData']['coordinates'], s_,  None )
                    else:
                        v_ = None
                else:
                    v_ = c.defaultMissingValue( p_[f], s_,  None )

            except KeyError:
                v_ = None


            d[s_].append( v_ )

    def setAction( self, p_, f, s, d ):

        for s_ in s:

            try:
                if f == c.action_meta2_flag:
                    v_ = c.defaultMissingValue( p_, s_,  None )
                elif f == c.action_player_flag:
                    v_ = c.defaultMissingValue( p_[f], 'id',  None )
                elif f == c.action_position_flag:
                    if 'position' in p_:
                        v_ = c.defaultMissingValue( p_[f], s_,  None )
                    else:
                        v_ = None
                else:
                    v_ = c.defaultMissingValue( p_[f], s_,  None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )

    def setPickoff( self, p_, f, s, d ):

        for s_ in s:

            try:
                if f == c.pickoff_meta2_flag:
                    v_ = c.defaultMissingValue( p_, s_,  None )
                else:
                    v_ = c.defaultMissingValue( p_[f], s_,  None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )

    def _init_datasets( self ):
        self.atbat = c.createDataset( c.play_about
                                    + c.play_result
                                    + c.play_count
                                    + c.play_matchup_batside
                                    + c.play_matchup_pitchhand
                                    + c.play_matchup_pitcher
                                    + c.play_matchup_batter
                                    + c.play_matchup_splits
                                    , c.play_atbat_meta
                                    )

        self.pitch  = c.createDataset( c.pitch_details
                                     + c.pitch_count
                                     + c.pitch_data
                                     + c.pitch_data_coord
                                     + c.pitch_data_breaks
                                     + c.pitch_hit_data
                                     + c.pitch_hit_data_coord
                                     , c.pitch_meta
                                     + c.pitch_meta2
                                     )

        self.action = c.createDataset( c.action_details
                                     + c.action_count
                                     + c.action_player
                                     + c.action_position
                                     , c.action_meta
                                     + c.action_meta2
                                     )

        self.pickoff = c.createDataset( c.pickoff_details
                                      + c.pickoff_count
                                      , c.pickoff_meta
                                      + c.pickoff_meta2
                                      )

        self.runner = c.createDataset( c.play_runner_movement
                                     + c.play_runner_details
                                     , c.play_runner_meta
                                     )
        self.credit = c.createDataset( c.play_credit_credit
                                     + c.play_credit_player
                                     + c.play_credit_position
                                     , c.play_credit_meta
                                     )

    def setData( self, game_pk ):

        self._init_datasets()

        for g_ in game_pk:

            self.json = c.parseJson( g_, c.playByPlay_file )

            if not c.jsonIsValid( self.json ):
                continue

            # Atbat
            for a_ in self.json['allPlays']:
                # Metadata ?
                self.atbat['gamePk'].append(g_)
                self.setAboutResultCount( a_, c.play_about_flag,  c.play_about,  self.atbat )
                self.setAboutResultCount( a_, c.play_result_flag, c.play_result, self.atbat )
                self.setAboutResultCount( a_, c.play_count_flag,  c.play_count,  self.atbat )

                self.setMatchup( a_, c.play_matchup_batside_flag,   c.play_matchup_batside,   self.atbat )
                self.setMatchup( a_, c.play_matchup_pitchhand_flag, c.play_matchup_pitchhand, self.atbat )
                self.setMatchup( a_, c.play_matchup_batter_flag,    c.play_matchup_batter,   self.atbat )
                self.setMatchup( a_, c.play_matchup_pitcher_flag,   c.play_matchup_pitcher,    self.atbat )
                self.setMatchup( a_, c.play_matchup_splits_flag,    c.play_matchup_splits,    self.atbat )


                # Splits:


                # Plays
                for p_ in a_['playEvents']:

                    if p_['type'] == 'pitch':
                        #Metadata
                        self.pitch['gamePk'].append(g_)
                        self.pitch['atBatIndex'].append(a_['atBatIndex'])
                        self.setPitch( p_, c.pitch_meta2_flag,          c.pitch_meta2,          self.pitch )
                        self.setPitch( p_, c.pitch_details_flag,        c.pitch_details,        self.pitch )
                        self.setPitch( p_, c.pitch_count_flag,          c.pitch_count,          self.pitch )
                        self.setPitch( p_, c.pitch_data_flag,           c.pitch_data,           self.pitch )
                        self.setPitch( p_, c.pitch_data_coord_flag,     c.pitch_data_coord,     self.pitch )
                        self.setPitch( p_, c.pitch_data_breaks_flag,    c.pitch_data_breaks,    self.pitch )
                        self.setPitch( p_, c.pitch_hit_data_flag,       c.pitch_hit_data,       self.pitch )
                        self.setPitch( p_, c.pitch_hit_data_coord_flag, c.pitch_hit_data_coord, self.pitch )

                    elif p_['type'] == 'action':
                        self.action['gamePk'].append(g_)
                        self.action['atBatIndex'].append(a_['atBatIndex'])
                        self.setAction( p_, c.action_meta2_flag,    c.action_meta2,    self.action )
                        self.setAction( p_, c.action_details_flag,  c.action_details,  self.action )
                        self.setAction( p_, c.action_count_flag,    c.action_count,    self.action )
                        self.setAction( p_, c.action_player_flag,   c.action_player,   self.action )
                        self.setAction( p_, c.action_position_flag, c.action_position, self.action )

                    elif p_['type'] == 'pickoff':
                        self.pickoff['gamePk'].append(g_)
                        self.pickoff['atBatIndex'].append(a_['atBatIndex'])
                        self.setPickoff( p_, c.pickoff_meta2_flag,   c.pickoff_meta2,   self.pickoff )
                        self.setPickoff( p_, c.pickoff_details_flag, c.pickoff_details, self.pickoff )
                        self.setPickoff( p_, c.pickoff_count_flag,   c.pickoff_count,   self.pickoff )

                # Runner ids

                # Runner
                for r_ in a_['runners']:
                    self.runner['gamePk'].append(g_)
                    self.runner['atBatIndex'].append(a_['atBatIndex'])
                    self.setRunner( r_, c.play_runner_movement_flag, c.play_runner_movement, self.runner )
                    self.setRunner( r_, c.play_runner_details_flag,  c.play_runner_details,  self.runner )

                    # Runner Credits
                    if 'credits' in r_.keys():

                        for c_ in r_['credits']:
                            # Metadata ?
                            self.credit['gamePk'].append(g_)
                            self.credit['atBatIndex'].append(a_['atBatIndex'])
                            self.setCredit( c_, c.play_credit_credit_flag,   c.play_credit_credit,   self.credit )
                            self.setCredit( c_, c.play_credit_player_flag,   c.play_credit_player,   self.credit )
                            self.setCredit( c_, c.play_credit_position_flag, c.play_credit_position, self.credit )
