import const as c

class people:

    def __init__( self ):
        self.json    = None
        self.game_pk = None
        self.people  = None

    def setPeople( self, f, s, d ):

        for s_ in s:

            try:
                if f == c.people_primaryPosition_flag :
                    v_ = c.defaultMissingValue( self.json['people'][0][f], s_, None )
                elif f in [ c.people_batSide_flag, c.people_pitchHand_flag ]:

                    if f in self.json['people'][0]:
                        v_ = c.defaultMissingValue( self.json['people'][0][f], 'code', None )
                    else:
                        v_ = None
                else:
                    v_ = c.defaultMissingValue( self.json['people'][0], s_ , None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )


    def setData( self, people_ids ):

        self.people = c.createDataset( c.people_primaryPosition
                                     + c.people_batSide
                                     + c.people_pitchHand
                                     , c.people_meta
                                     )

        for id_ in people_ids:
            self.json    = c.parseJson( id_, c.people_file )

            if not c.jsonIsValid( self.json ):
                continue

            self.setPeople( c.people_meta_flag,            c.people_meta,             self.people )
            self.setPeople( c.people_primaryPosition_flag, c.people_primaryPosition,  self.people )
            self.setPeople( c.people_batSide_flag,         c.people_batSide,          self.people )
            self.setPeople( c.people_pitchHand_flag,       c.people_pitchHand,        self.people )


        return self.people
