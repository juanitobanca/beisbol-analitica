import const as c

# La API de MLB acepta hasta ~500 ids por llamada, pero 100 es un tamaño conservador
# que evita URLs demasiado largas y facilita el retry si un batch falla.
PEOPLE_BATCH_SIZE = 100

class people:

    def __init__( self ):
        self.json    = None
        self.game_pk = None
        self.people  = None

    def setPeople( self, person, f, s, d ):
        """
        Extrae campos de un dict 'person' individual (un elemento de json['people']).
        Antes recibía self.json['people'][0] implícitamente; ahora el caller
        itera sobre todos los elementos y pasa cada uno aquí.
        """
        for s_ in s:

            try:
                if f == c.people_primaryPosition_flag:
                    v_ = c.defaultMissingValue( person[f], s_, None )
                elif f in [ c.people_batSide_flag, c.people_pitchHand_flag ]:
                    if f in person:
                        v_ = c.defaultMissingValue( person[f], 'code', None )
                    else:
                        v_ = None
                else:
                    v_ = c.defaultMissingValue( person, s_, None )

            except KeyError:
                v_ = None

            d[s_].append( v_ )


    def _init_datasets( self ):

        self.people = c.createDataset( c.people_primaryPosition
                                     + c.people_batSide
                                     + c.people_pitchHand
                                     , c.people_meta
                                     )

    def setData( self, people_ids ):

        self._init_datasets()

        # Filtrar None/vacíos que pueden llegar desde ppl_set/official_set
        valid_ids = [ i for i in people_ids if i ]

        # Partir en batches para reducir ~1,500 llamadas a ~15
        id_list = list(valid_ids)
        for start in range( 0, len(id_list), PEOPLE_BATCH_SIZE ):
            batch = id_list[ start : start + PEOPLE_BATCH_SIZE ]

            # "123,456,789" — formato que espera ?personIds=
            parsing_arg = ','.join( str(int(i)) for i in batch )

            self.json = c.parseJson( parsing_arg, c.ENDPOINT_PEOPLE_BATCH )

            if not c.jsonIsValid( self.json ):
                continue

            # La respuesta batch devuelve una lista; iterar sobre cada persona
            for person in self.json['people']:
                self.setPeople( person, c.people_meta_flag,            c.people_meta,            self.people )
                self.setPeople( person, c.people_primaryPosition_flag, c.people_primaryPosition, self.people )
                self.setPeople( person, c.people_batSide_flag,         c.people_batSide,         self.people )
                self.setPeople( person, c.people_pitchHand_flag,       c.people_pitchHand,       self.people )

        return self.people
