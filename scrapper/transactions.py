import const as c

class transactions:

    def __init__( self ):
        self.json    = None
        self.transactions  = None

    def setTransactions( self, f, s, d ):

        for t in self.json['transactions']:

            for s_ in s:

                try:
                    if f in [ c.transactions_person_flag,  c.transactions_toTeam_flag ]:
                        v_ = c.defaultMissingValue( t[f], 'id', None )

                    elif s_ == 'transactionDate':
                        v_ = c.defaultMissingValue( t, 'date', None )

                    else:
                        v_ = c.defaultMissingValue( t, s_, None )

                except KeyError:
                    v_ = None

                d[s_].append( v_ )

    def _init_datasets( self ):

        self.transactions = c.createDataset( c.transactions_personId
                                           + c.transactions_toTeamId
                                           + c.transactions_teamId
                                           , c.transactions_meta
                                           )

    def setData( self, team_ids, startDate, endDate ):

        self._init_datasets()

        for tm_ in team_ids:

            if not tm_:
                continue

            parsing_arg = 'teamId='+str(tm_)+'&startDate='+startDate+'&endDate='+endDate

            self.teamId = tm_
            self.json    = c.parseJson( parsing_arg, c.transactions_file )
            self.setTransactions( c.transactions_meta_flag,   c.transactions_meta,     self.transactions )
            self.setTransactions( c.transactions_person_flag, c.transactions_personId, self.transactions )
            self.setTransactions( c.transactions_toTeam_flag, c.transactions_toTeamId, self.transactions )

            self.transactions['teamId'] += [tm_] * len(self.json['transactions'])

        return self.transactions
