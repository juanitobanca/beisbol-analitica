import const as c


class transactions:

    def __init__(self):
        self.json         = None
        self.transactions = None

    def _init_datasets(self):
        self.transactions = c.createDataset(
            c.transactions_personId
            + c.transactions_toTeamId
            + c.transactions_teamId
            , c.transactions_meta
        )

    def _append_transaction(self, t, team_id, d):
        """
        Escribe exactamente una fila en el dataset con todas sus columnas.

        El bug original llamaba a setTransactions tres veces (una por flag),
        y cada llamada iteraba self.json['transactions'] completo.  Eso
        producía N×(número de flags) filas en unas columnas y N filas en
        otras, desalineando el DataFrame resultante.

        Ahora hay una sola pasada por transacción que llena todas las
        columnas a la vez, garantizando que cada lista del dataset crece
        exactamente en 1 por llamada.
        """

        # --- campos de meta ---
        d['id'].append(             t.get('id') )
        d['transactionDate'].append(t.get('date') )          # la API usa 'date', no 'transactionDate'
        d['effectiveDate'].append(  t.get('effectiveDate') )
        d['resolutionDate'].append( t.get('resolutionDate') )
        d['typeCode'].append(       t.get('typeCode') )
        d['typeDesc'].append(       t.get('typeDesc') )
        d['description'].append(    t.get('description') )

        # --- ids de entidades relacionadas ---
        person   = t.get(c.transactions_person_flag)
        to_team  = t.get(c.transactions_toTeam_flag)

        d['personId'].append( person.get('id')  if person  else None )
        d['toTeamId'].append( to_team.get('id') if to_team else None )
        d['teamId'].append(   team_id )

    def setData(self, team_ids, startDate, endDate):

        self._init_datasets()

        for tm_ in team_ids:

            if not tm_:
                continue

            parsing_arg = 'teamId=' + str(tm_) + '&startDate=' + startDate + '&endDate=' + endDate
            self.json   = c.parseJson(parsing_arg, c.transactions_file)

            if not c.jsonIsValid(self.json):
                continue

            for t in self.json['transactions']:
                self._append_transaction(t, tm_, self.transactions)

        return self.transactions
