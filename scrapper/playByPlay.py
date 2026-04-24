import const as c
from extractor import extract_fields, nav, nav_id, nav_code, nav_description


class playByPlay:

    def __init__(self):
        self.json    = None
        self.atbat   = None
        self.runner  = None
        self.credit  = None
        self.pitch   = None
        self.action  = None
        self.pickoff = None

    # ------------------------------------------------------------------
    # At-bat: about / result / count
    # ------------------------------------------------------------------

    def setAboutResultCount(self, play, flag, fields, dataset):
        extract_fields(play.get(flag), fields, dataset, nav)

    # ------------------------------------------------------------------
    # Matchup
    # ------------------------------------------------------------------

    def setMatchup(self, play, flag, fields, dataset):
        """
        Antes: un if/elif por cada nombre de campo para decidir si extraer
        'code', 'description', 'id' o el campo directo.
        Ahora: un resolver que toma esa decisión de forma declarativa.
        """
        matchup_sub = play.get('matchup', {}).get(flag)

        def resolver(node, field):
            if field.endswith('Code'):        return nav_code(node)
            if field.endswith('Description'): return nav_description(node)
            if field.endswith('Id'):          return nav_id(node)
            return nav(node, field)           # ej. menOnBase

        extract_fields(matchup_sub, fields, dataset, resolver)

    # ------------------------------------------------------------------
    # Runners
    # ------------------------------------------------------------------

    def setRunner(self, runner, flag, fields, dataset):
        """
        Casos especiales de runner (runnerId, responsiblePitcherId,
        startBase, endBase) se resuelven con un resolver dedicado.
        """
        def resolver(node, field):
            if field == 'runnerId':
                return nav_id(runner.get('details', {}).get('runner'))
            if field == 'responsiblePitcherId':
                return nav_id(runner.get('details', {}).get('responsiblePitcher'))
            if field == 'endBase':
                return nav(runner.get(flag), 'end')
            if field == 'startBase':
                return nav(runner.get(flag), 'start')
            return nav(runner.get(flag), field)

        extract_fields(runner.get(flag), fields, dataset, resolver)

    # ------------------------------------------------------------------
    # Credits
    # ------------------------------------------------------------------

    def setCredit(self, credit_node, flag, fields, dataset):
        def resolver(node, field):
            if flag == c.play_credit_credit_flag:
                return nav(credit_node, field)
            if flag == c.play_credit_player_flag:
                return nav_id(credit_node.get(flag))
            return nav(credit_node.get(flag), field)

        extract_fields(credit_node, fields, dataset, resolver)

    # ------------------------------------------------------------------
    # Pitches
    # ------------------------------------------------------------------

    def setPitch(self, pitch, flag, fields, dataset):
        """
        La lógica de navegación de pitch tenía 8 ramas.
        Se consolidan en un resolver que mapea flag → nodo correcto.
        """
        def resolver(node, field):
            if flag == c.pitch_meta2_flag:
                return nav(pitch, field)

            if flag == c.pitch_details_flag:
                details = pitch.get('details', {})
                if field == 'callCode':        return nav_code(details.get('call'))
                if field == 'callDescription': return nav_description(details.get('call'))
                if field == 'typeCode':        return nav_code(details.get('type'))
                if field == 'typeDescription': return nav_description(details.get('type'))
                return nav(details, field)

            if flag == c.pitch_count_flag:
                return nav(pitch.get('count'), field)

            if flag == c.pitch_data_flag:
                return nav(pitch.get('pitchData'), field)

            if flag in (c.pitch_data_coord_flag, c.pitch_data_breaks_flag):
                return nav(pitch.get('pitchData', {}).get(flag), field)

            if flag == c.pitch_hit_data_flag:
                return nav(pitch.get('hitData'), field)

            if flag == c.pitch_hit_data_coord_flag:
                hit = pitch.get('hitData')
                return nav(hit.get('coordinates') if hit else None, field)

            return nav(pitch.get(flag), field)

        extract_fields(None, fields, dataset, resolver)

    # ------------------------------------------------------------------
    # Actions
    # ------------------------------------------------------------------

    def setAction(self, event, flag, fields, dataset):
        def resolver(node, field):
            if flag == c.action_meta2_flag:
                return nav(event, field)
            if flag == c.action_player_flag:
                return nav_id(event.get(flag))
            if flag == c.action_position_flag:
                return nav(event.get(flag), field) if 'position' in event else None
            return nav(event.get(flag), field)

        extract_fields(None, fields, dataset, resolver)

    # ------------------------------------------------------------------
    # Pickoffs
    # ------------------------------------------------------------------

    def setPickoff(self, event, flag, fields, dataset):
        def resolver(node, field):
            if flag == c.pickoff_meta2_flag:
                return nav(event, field)
            return nav(event.get(flag), field)

        extract_fields(None, fields, dataset, resolver)

    # ------------------------------------------------------------------
    # Dataset init — sin cambios
    # ------------------------------------------------------------------

    def _init_datasets(self):
        self.atbat = c.createDataset(
            c.play_about + c.play_result + c.play_count
            + c.play_matchup_batside + c.play_matchup_pitchhand
            + c.play_matchup_pitcher + c.play_matchup_batter + c.play_matchup_splits,
            c.play_atbat_meta,
        )

        self.pitch = c.createDataset(
            c.pitch_details + c.pitch_count + c.pitch_data
            + c.pitch_data_coord + c.pitch_data_breaks
            + c.pitch_hit_data + c.pitch_hit_data_coord,
            c.pitch_meta + c.pitch_meta2,
        )

        self.action = c.createDataset(
            c.action_details + c.action_count + c.action_player + c.action_position,
            c.action_meta + c.action_meta2,
        )

        self.pickoff = c.createDataset(
            c.pickoff_details + c.pickoff_count,
            c.pickoff_meta + c.pickoff_meta2,
        )

        self.runner = c.createDataset(
            c.play_runner_movement + c.play_runner_details,
            c.play_runner_meta,
        )

        self.credit = c.createDataset(
            c.play_credit_credit + c.play_credit_player + c.play_credit_position,
            c.play_credit_meta,
        )

    # ------------------------------------------------------------------
    # Main entry point — sin cambios de lógica
    # ------------------------------------------------------------------

    def setData(self, game_pks):
        self._init_datasets()

        for game_pk in game_pks:
            self.json = c.parseJson(game_pk, c.ENDPOINT_PLAY_BY_PLAY)

            if not c.jsonIsValid(self.json):
                continue

            for play in self.json['allPlays']:
                self.atbat['gamePk'].append(game_pk)
                self.setAboutResultCount(play, c.play_about_flag,  c.play_about,  self.atbat)
                self.setAboutResultCount(play, c.play_result_flag, c.play_result, self.atbat)
                self.setAboutResultCount(play, c.play_count_flag,  c.play_count,  self.atbat)

                self.setMatchup(play, c.play_matchup_batside_flag,   c.play_matchup_batside,   self.atbat)
                self.setMatchup(play, c.play_matchup_pitchhand_flag, c.play_matchup_pitchhand, self.atbat)
                self.setMatchup(play, c.play_matchup_batter_flag,    c.play_matchup_batter,    self.atbat)
                self.setMatchup(play, c.play_matchup_pitcher_flag,   c.play_matchup_pitcher,   self.atbat)
                self.setMatchup(play, c.play_matchup_splits_flag,    c.play_matchup_splits,    self.atbat)

                for event in play['playEvents']:
                    event_type = event['type']

                    if event_type == 'pitch':
                        self.pitch['gamePk'].append(game_pk)
                        self.pitch['atBatIndex'].append(play['atBatIndex'])
                        self.setPitch(event, c.pitch_meta2_flag,          c.pitch_meta2,          self.pitch)
                        self.setPitch(event, c.pitch_details_flag,        c.pitch_details,        self.pitch)
                        self.setPitch(event, c.pitch_count_flag,          c.pitch_count,          self.pitch)
                        self.setPitch(event, c.pitch_data_flag,           c.pitch_data,           self.pitch)
                        self.setPitch(event, c.pitch_data_coord_flag,     c.pitch_data_coord,     self.pitch)
                        self.setPitch(event, c.pitch_data_breaks_flag,    c.pitch_data_breaks,    self.pitch)
                        self.setPitch(event, c.pitch_hit_data_flag,       c.pitch_hit_data,       self.pitch)
                        self.setPitch(event, c.pitch_hit_data_coord_flag, c.pitch_hit_data_coord, self.pitch)

                    elif event_type == 'action':
                        self.action['gamePk'].append(game_pk)
                        self.action['atBatIndex'].append(play['atBatIndex'])
                        self.setAction(event, c.action_meta2_flag,    c.action_meta2,    self.action)
                        self.setAction(event, c.action_details_flag,  c.action_details,  self.action)
                        self.setAction(event, c.action_count_flag,    c.action_count,    self.action)
                        self.setAction(event, c.action_player_flag,   c.action_player,   self.action)
                        self.setAction(event, c.action_position_flag, c.action_position, self.action)

                    elif event_type == 'pickoff':
                        self.pickoff['gamePk'].append(game_pk)
                        self.pickoff['atBatIndex'].append(play['atBatIndex'])
                        self.setPickoff(event, c.pickoff_meta2_flag,   c.pickoff_meta2,   self.pickoff)
                        self.setPickoff(event, c.pickoff_details_flag, c.pickoff_details, self.pickoff)
                        self.setPickoff(event, c.pickoff_count_flag,   c.pickoff_count,   self.pickoff)

                for runner in play['runners']:
                    self.runner['gamePk'].append(game_pk)
                    self.runner['atBatIndex'].append(play['atBatIndex'])
                    self.setRunner(runner, c.play_runner_movement_flag, c.play_runner_movement, self.runner)
                    self.setRunner(runner, c.play_runner_details_flag,  c.play_runner_details,  self.runner)

                    for credit in runner.get('credits', []):
                        self.credit['gamePk'].append(game_pk)
                        self.credit['atBatIndex'].append(play['atBatIndex'])
                        self.setCredit(credit, c.play_credit_credit_flag,   c.play_credit_credit,   self.credit)
                        self.setCredit(credit, c.play_credit_player_flag,   c.play_credit_player,   self.credit)
                        self.setCredit(credit, c.play_credit_position_flag, c.play_credit_position, self.credit)
