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

    def _append_transaction(self, transaction, team_id, dataset):
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
        dataset['id'].append(             transaction.get('id') )
        dataset['transactionDate'].append(transaction.get('date') )          # la API usa 'date', no 'transactionDate'
        dataset['effectiveDate'].append(  transaction.get('effectiveDate') )
        dataset['resolutionDate'].append( transaction.get('resolutionDate') )
        dataset['typeCode'].append(       transaction.get('typeCode') )
        dataset['typeDesc'].append(       transaction.get('typeDesc') )
        dataset['description'].append(    transaction.get('description') )

        # --- ids de entidades relacionadas ---
        person   = transaction.get(c.transactions_person_flag)
        to_team  = transaction.get(c.transactions_toTeam_flag)

        dataset['personId'].append( person.get('id')  if person  else None )
        dataset['toTeamId'].append( to_team.get('id') if to_team else None )
        dataset['teamId'].append(   team_id )

    def setData(self, team_ids, startDate, endDate):

        self._init_datasets()

        for team_id in team_ids:

            if not team_id:
                continue

            parsing_arg = 'teamId=' + str(team_id) + '&startDate=' + startDate + '&endDate=' + endDate
            self.json   = c.parseJson(parsing_arg, c.ENDPOINT_TRANSACTIONS)

            if not c.jsonIsValid(self.json):
                continue

            for transaction in self.json['transactions']:
                self._append_transaction(transaction, team_id, self.transactions)

        return self.transactions
