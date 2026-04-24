import const as c
from extractor import extract_fields, nav, nav_id, nav_name


class contextMetrics:

    def __init__(self):
        self.json           = None
        self.contextMetrics = None

    # ------------------------------------------------------------------
    # Extracción de métricas de contexto
    # ------------------------------------------------------------------

    def setContextMetrics(self, flag, fields, d):
        """
        Antes: un método con 5 ramas if/elif que hacían manipulación de
        strings para derivar el nombre de sub-clave (s_[4].lower()+s_[5:]).
        Esa magia implícita se reemplaza con un resolver explícito por flag.
        """
        game = self.json.get('game', {})

        def resolver_game(node, field):
            return nav(game, field)

        def resolver_status(node, field):
            return nav(game.get('status'), field)

        def resolver_venue(node, field):
            # Campos como 'venueId', 'venueName', 'venueLink'
            # → sub-clave sin el prefijo 'venue' y en minúsculas
            sub_key = field[5].lower() + field[6:]
            return nav(game.get('venue'), sub_key)

        def resolver_team_side(node, field):
            # Campos como 'awayWins', 'homeScore', 'homeId', 'awayName'
            # → quitar prefijo de 4 chars (away/home), primera letra en minúscula
            sub_key = field[4].lower() + field[5:]
            teams   = game.get('teams', {})
            side    = teams.get(flag, {})
            if sub_key in ('wins', 'losses', 'pct'):
                return nav(side.get('leagueRecord'), sub_key)
            if sub_key in ('id', 'name'):
                return nav(side.get('team'), sub_key)
            return nav(side, sub_key)

        resolver_map = {
            c.contextGame_flag:       resolver_game,
            c.contextGameStatus_flag: resolver_status,
            c.contextGameVenue_flag:  resolver_venue,
            c.contextGameAway_flag:   resolver_team_side,
            c.contextGameHome_flag:   resolver_team_side,
        }

        resolver = resolver_map.get(flag, lambda n, f: nav(self.json, f))
        extract_fields(None, fields, d, resolver)

    # ------------------------------------------------------------------
    # Dataset init
    # ------------------------------------------------------------------

    def _init_datasets(self):
        self.contextMetrics = c.createDataset(
            c.contextGame
            + c.contextGameStatus
            + c.contextGameAway
            + c.contextGameHome
            + c.contextGameVenue,
            None,
        )

    # ------------------------------------------------------------------
    # Main entry point — sin cambios de lógica
    # ------------------------------------------------------------------

    def setData(self, game_pks, major_league=None, major_league_id=None):
        self._init_datasets()

        for g_ in game_pks:
            self.json = c.parseJson(g_, c.context_file)

            if not c.jsonIsValid(self.json):
                continue

            self.setContextMetrics(c.contextGame_flag,       c.contextGame,       self.contextMetrics)
            self.setContextMetrics(c.contextGameStatus_flag, c.contextGameStatus, self.contextMetrics)
            self.setContextMetrics(c.contextGameAway_flag,   c.contextGameAway,   self.contextMetrics)
            self.setContextMetrics(c.contextGameHome_flag,   c.contextGameHome,   self.contextMetrics)
            self.setContextMetrics(c.contextGameVenue_flag,  c.contextGameVenue,  self.contextMetrics)

        n = len(self.contextMetrics['gamePk'])
        self.contextMetrics['majorLeague']   = [major_league]    * n
        self.contextMetrics['majorLeagueId'] = [major_league_id] * n

        return self.contextMetrics
