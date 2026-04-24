import const as c
from extractor import extract_fields, nav, nav_id, nav_code, nav_name, nav_link


class boxscore:

    def __init__(self):
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

    # ------------------------------------------------------------------
    # Metadata helpers (sin cambios de comportamiento)
    # ------------------------------------------------------------------

    def setMetadata(self, dataset, team_side, player_key):
        dataset['gamePk'].append(self.game_pk)
        dataset['teamId'].append(self.json['teams'][team_side]['team']['id'])
        dataset['teamType'].append(team_side)
        if player_key:
            dataset['playerId'].append(self.json['teams'][team_side]['players'][player_key]['person']['id'])

    # ------------------------------------------------------------------
    # Officials
    # ------------------------------------------------------------------

    def setOfficialTypes(self, official, dataset):
        extract_fields(official,             ['officialId'], dataset, lambda n, f: nav_id(n.get('official')))
        extract_fields(official,             ['position'],   dataset, lambda n, f: nav(n, 'officialType'))

    # ------------------------------------------------------------------
    # Game info (estructura especial: lista de dicts label/value)
    # ------------------------------------------------------------------

    def setInfo(self, flag, fields, dataset):
        """
        La estructura info es una lista [{label, value}, ...].
        Construimos un índice label->value una sola vez por juego,
        en lugar de hacer un loop anidado por cada campo.
        """
        label_map = {'weather': None, 'wind': None, 'attendance': None}

        if flag in self.json:
            for item in self.json[flag]:
                label = item.get('label', '').lower()
                if label == 'att':
                    label_map['attendance'] = item.get('value')
                elif label in label_map:
                    label_map[label] = item.get('value')

        for field in fields:
            dataset[field].append(label_map.get(field))

    # ------------------------------------------------------------------
    # Batting order
    # ------------------------------------------------------------------

    def setBattingOrder(self, team_side, dataset):
        try:
            players = self.json['teams'][team_side]['players']
            for pid_key, player in players.items():
                self.setMetadata(dataset, team_side, None)
                dataset['playerId'].append(int(pid_key.replace('ID', '')))
                dataset['battingOrder'].append(player.get('battingOrder'))
        except Exception as e:
            print(f'setBattingOrder error: {e}')

    # ------------------------------------------------------------------
    # Team data
    # ------------------------------------------------------------------

    def setTeam(self, team_side, flag, fields, dataset):
        """
        Antes: un método con 5 ramas if/elif que inferían cómo navegar
        el JSON a partir de convenciones en el nombre del campo (ej. 'Id'
        en el nombre → extraer sub-clave 'id').  Esa magia implícita se
        reemplaza con resolvers explícitos según el flag.
        """
        team_node = self.json['teams'][team_side]

        if flag == c.box_team_meta2_flag:
            extract_fields(team_node.get('team'), fields, dataset, nav)

        else:
            sub_node = team_node.get('team', {}).get(flag)

            def resolver_sub(node, field):
                if 'Id'   in field: return nav_id(sub_node)
                if 'Name' in field: return nav_name(sub_node)
                if 'Link' in field: return nav_link(sub_node)
                return nav(team_node.get('teamStats', {}).get(flag), field)

            extract_fields(sub_node, fields, dataset, resolver_sub)

    # ------------------------------------------------------------------
    # Player sub-nodos (gameStatus, person, position)
    # ------------------------------------------------------------------

    def setPlayer(self, team_side, player_key, flag, fields, dataset):
        node = self.json['teams'][team_side]['players'][player_key].get(flag)
        extract_fields(node, fields, dataset, nav)

    # ------------------------------------------------------------------
    # Stats (player y team comparten el mismo método)
    # ------------------------------------------------------------------

    def setStats(self, team_side, player_key, flag, fields, dataset):
        try:
            if player_key:
                node = self.json['teams'][team_side]['players'][player_key]['stats'].get(flag)
            else:
                node = self.json['teams'][team_side]['teamStats'].get(flag)
        except KeyError:
            node = None
        extract_fields(node, fields, dataset, nav)

    # ------------------------------------------------------------------
    # Dataset init — sin cambios
    # ------------------------------------------------------------------

    def _init_datasets(self):
        self.info = c.createDataset(c.box_info_details, c.box_info_meta)

        self.official_types = c.createDataset(c.box_officials_details, c.box_officials_meta)

        self.team = c.createDataset(
            c.box_team_meta2 + c.box_team_league + c.box_team_venue + c.box_team_division,
            c.box_team_meta,
        )

        self.team_batting  = c.createDataset(c.box_team_batting_stats,  c.box_team_meta)
        self.team_pitching = c.createDataset(c.box_team_pitching_stats, c.box_team_meta)
        self.team_fielding = c.createDataset(c.box_team_fielding_stats, c.box_team_meta)

        self.team_batting_order = c.createDataset(c.box_team_batting_order_fields, c.box_team_batting_order_meta)

        self.player_batting  = c.createDataset(c.box_player_batting_stats,  c.box_player_meta)
        self.player_pitching = c.createDataset(c.box_player_pitching_stats, c.box_player_meta)
        self.player_fielding = c.createDataset(c.box_player_fielding_stats, c.box_player_meta)

        self.player_game_info = c.createDataset(
            c.box_player_player_gameStatus + c.box_player_player_person + c.box_player_player_position,
            c.box_player_meta,
        )

        self.player_game_positions = c.createDataset(c.box_player_player_allPositions, c.box_player_meta)

    # ------------------------------------------------------------------
    # Main entry point — sin cambios de lógica
    # ------------------------------------------------------------------

    def setData(self, game_pks):
        self._init_datasets()

        for game_pk in game_pks:
            self.game_pk = game_pk
            self.json    = c.parseJson(game_pk, c.ENDPOINT_BOXSCORE)

            if not c.jsonIsValid(self.json):
                print('Invalid JSON, skipping.')
                continue

            self.info['gamePk'].append(game_pk)
            self.setInfo(c.box_info_flag, c.box_info_details, self.info)

            for official in self.json['officials']:
                self.official_types['gamePk'].append(game_pk)
                self.setOfficialTypes(official, self.official_types)

            for team_side in self.json['teams']:
                self.setMetadata(self.team, team_side, None)
                self.setTeam(team_side, c.box_team_meta2_flag,    c.box_team_meta2,    self.team)
                self.setTeam(team_side, c.box_team_league_flag,   c.box_team_league,   self.team)
                self.setTeam(team_side, c.box_team_venue_flag,    c.box_team_venue,    self.team)
                self.setTeam(team_side, c.box_team_division_flag, c.box_team_division, self.team)

                self.setMetadata(self.team_batting, team_side, None)
                self.setStats(team_side, None, c.box_team_batting_flag,  c.box_team_batting_stats,  self.team_batting)

                self.setMetadata(self.team_pitching, team_side, None)
                self.setStats(team_side, None, c.box_team_pitching_flag, c.box_team_pitching_stats, self.team_pitching)

                self.setMetadata(self.team_fielding, team_side, None)
                self.setStats(team_side, None, c.box_team_fielding_flag, c.box_team_fielding_stats, self.team_fielding)

                self.setBattingOrder(team_side, self.team_batting_order)

                for player_key in self.json['teams'][team_side]['players']:
                    self.setMetadata(self.player_batting,   team_side, player_key)
                    self.setMetadata(self.player_pitching,  team_side, player_key)
                    self.setMetadata(self.player_fielding,  team_side, player_key)
                    self.setMetadata(self.player_game_info, team_side, player_key)

                    self.setStats(team_side, player_key, c.box_player_batting_flag,  c.box_player_batting_stats,  self.player_batting)
                    self.setStats(team_side, player_key, c.box_player_pitching_flag, c.box_player_pitching_stats, self.player_pitching)
                    self.setStats(team_side, player_key, c.box_player_fielding_flag, c.box_player_fielding_stats, self.player_fielding)

                    self.setPlayer(team_side, player_key, c.box_player_player_gameStatus_flag, c.box_player_player_gameStatus, self.player_game_info)
                    self.setPlayer(team_side, player_key, c.box_player_player_person_flag,     c.box_player_player_person,     self.player_game_info)
                    self.setPlayer(team_side, player_key, c.box_player_player_position_flag,   c.box_player_player_position,   self.player_game_info)

                    player_node = self.json['teams'][team_side]['players'][player_key]
                    for position in player_node.get('allPositions', []):
                        self.setMetadata(self.player_game_positions, team_side, player_key)
                        extract_fields(position, c.box_player_player_allPositions, self.player_game_positions, nav)
