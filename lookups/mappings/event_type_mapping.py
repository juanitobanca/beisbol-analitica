
# Dictionary mapping each MLB event code to details about the event

event_type_map =  {
    "pickoff_1b": {
        "baseRunningEvent": True,
        "description": "Pickoff 1B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_2b": {
        "baseRunningEvent": True,
        "description": "Pickoff 2B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_3b": {
        "baseRunningEvent": True,
        "description": "Pickoff 3B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_error_1b": {
        "baseRunningEvent": True,
        "description": "Pickoff Error 1B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_error_2b": {
        "baseRunningEvent": True,
        "description": "Pickoff Error 2B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_error_3b": {
        "baseRunningEvent": True,
        "description": "Pickoff Error 3B",
        "hit": False,
        "plateAppearance": False
    },
    "no_pitch": {
        "baseRunningEvent": False,
        "description": "No Pitch",
        "hit": False,
        "plateAppearance": False
    },
    "single": {
        "baseRunningEvent": False,
        "description": "Single",
        "hit": True,
        "plateAppearance": True
    },
    "double": {
        "baseRunningEvent": False,
        "description": "Double",
        "hit": True,
        "plateAppearance": True
    },
    "triple": {
        "baseRunningEvent": False,
        "description": "Triple",
        "hit": True,
        "plateAppearance": True
    },
    "home_run": {
        "baseRunningEvent": False,
        "description": "Home Run",
        "hit": True,
        "plateAppearance": True
    },
    "double_play": {
        "baseRunningEvent": False,
        "description": "Double Play",
        "hit": False,
        "plateAppearance": True
    },
    "field_error": {
        "baseRunningEvent": False,
        "description": "Field Error",
        "hit": False,
        "plateAppearance": True
    },
    "error": {
        "baseRunningEvent": True,
        "description": "Error",
        "hit": False,
        "plateAppearance": False
    },
    "field_out": {
        "baseRunningEvent": False,
        "description": "Field Out",
        "hit": False,
        "plateAppearance": True
    },
    "fielders_choice": {
        "baseRunningEvent": False,
        "description": "Fielders Choice",
        "hit": False,
        "plateAppearance": True
    },
    "fielders_choice_out": {
        "baseRunningEvent": False,
        "description": "Fielders Choice Out",
        "hit": False,
        "plateAppearance": True
    },
    "force_out": {
        "baseRunningEvent": False,
        "description": "Forceout",
        "hit": False,
        "plateAppearance": True
    },
    "grounded_into_double_play": {
        "baseRunningEvent": False,
        "description": "Grounded Into DP",
        "hit": False,
        "plateAppearance": True
    },
    "grounded_into_triple_play": {
        "baseRunningEvent": False,
        "description": "Grounded Into TP",
        "hit": False,
        "plateAppearance": False
    },
    "strikeout": {
        "baseRunningEvent": False,
        "description": "Strikeout",
        "hit": False,
        "plateAppearance": True
    },
    "strike_out": {
        "baseRunningEvent": False,
        "description": "Strike Out",
        "hit": False,
        "plateAppearance": True
    },
    "strikeout_double_play": {
        "baseRunningEvent": False,
        "description": "Strikeout Double Play",
        "hit": False,
        "plateAppearance": True
    },
    "strikeout_triple_play": {
        "baseRunningEvent": False,
        "description": "Strikeout Triple Play",
        "hit": False,
        "plateAppearance": True
    },
    "triple_play": {
        "baseRunningEvent": False,
        "description": "Triple Play",
        "hit": False,
        "plateAppearance": True
    },
    "sac_fly": {
        "baseRunningEvent": False,
        "description": "Sac Fly",
        "hit": False,
        "plateAppearance": True
    },
    "catcher_interf": {
        "baseRunningEvent": False,
        "description": "Catcher Interference",
        "hit": False,
        "plateAppearance": True
    },
    "batter_interference": {
        "baseRunningEvent": False,
        "description": "Batter Interference",
        "hit": False,
        "plateAppearance": True
    },
    "fielder_interference": {
        "baseRunningEvent": False,
        "description": "Fielder Interference",
        "hit": False,
        "plateAppearance": False
    },
    "runner_interference": {
        "baseRunningEvent": False,
        "description": "Runner Interference",
        "hit": False,
        "plateAppearance": False
    },
    "fan_interference": {
        "baseRunningEvent": False,
        "description": "Fan Interference",
        "hit": False,
        "plateAppearance": True
    },
    "batter_turn": {
        "baseRunningEvent": False,
        "description": "Batter Turn",
        "hit": False,
        "plateAppearance": False
    },
    "ejection": {
        "baseRunningEvent": False,
        "description": "Ejection",
        "hit": False,
        "plateAppearance": False
    },
    "cs_double_play": {
        "baseRunningEvent": True,
        "description": "Cs Double Play",
        "hit": False,
        "plateAppearance": False
    },
    "defensive_indiff": {
        "baseRunningEvent": True,
        "description": "Defensive Indiff",
        "hit": False,
        "plateAppearance": False
    },
    "sac_fly_double_play": {
        "baseRunningEvent": False,
        "description": "Sac Fly Double Play",
        "hit": False,
        "plateAppearance": True
    },
    "sac_bunt": {
        "baseRunningEvent": False,
        "description": "Sac Bunt",
        "hit": False,
        "plateAppearance": True
    },
    "sac_bunt_double_play": {
        "baseRunningEvent": False,
        "description": "Sac Bunt Double Play",
        "hit": False,
        "plateAppearance": True
    },
    "walk": {
        "baseRunningEvent": False,
        "description": "Walk",
        "hit": False,
        "plateAppearance": True
    },
    "intent_walk": {
        "baseRunningEvent": False,
        "description": "Intent Walk",
        "hit": False,
        "plateAppearance": True
    },
    "hit_by_pitch": {
        "baseRunningEvent": False,
        "description": "Hit By Pitch",
        "hit": False,
        "plateAppearance": True
    },
    "injury": {
        "baseRunningEvent": False,
        "description": "Injury",
        "hit": False,
        "plateAppearance": False
    },
    "os_ruling_pending_prior": {
        "baseRunningEvent": False,
        "description": "Official Scorer Ruling Pending",
        "hit": False,
        "plateAppearance": False
    },
    "os_ruling_pending_primary": {
        "baseRunningEvent": False,
        "description": "Official Scorer Ruling Pending",
        "hit": False,
        "plateAppearance": True
    },
    "at_bat_start": {
        "baseRunningEvent": False,
        "description": "At Bat Start",
        "hit": False,
        "plateAppearance": False
    },
    "passed_ball": {
        "baseRunningEvent": True,
        "description": "Passed Ball",
        "hit": False,
        "plateAppearance": False
    },
    "other_advance": {
        "baseRunningEvent": True,
        "description": "Other Advance",
        "hit": False,
        "plateAppearance": False
    },
    "runner_double_play": {
        "baseRunningEvent": True,
        "description": "Runner Double Play",
        "hit": False,
        "plateAppearance": False
    },
    "runner_placed": {
        "baseRunningEvent": False,
        "description": "Runner Placed On Base",
        "hit": False,
        "plateAppearance": False
    },
    "pitching_substitution": {
        "baseRunningEvent": False,
        "description": "Pitching Substitution",
        "hit": False,
        "plateAppearance": False
    },
    "offensive_substitution": {
        "baseRunningEvent": False,
        "description": "Offensive Substitution",
        "hit": False,
        "plateAppearance": False
    },
    "defensive_switch": {
        "baseRunningEvent": False,
        "description": "Defensive Switch",
        "hit": False,
        "plateAppearance": False
    },
    "umpire_substitution": {
        "baseRunningEvent": False,
        "description": "Umpire Substitution",
        "hit": False,
        "plateAppearance": False
    },
    "pitcher_switch": {
        "baseRunningEvent": False,
        "description": "Pitcher Switch",
        "hit": False,
        "plateAppearance": False
    },
    "game_advisory": {
        "baseRunningEvent": False,
        "description": "Game Advisory",
        "hit": False,
        "plateAppearance": False
    },
    "stolen_base": {
        "baseRunningEvent": False,
        "description": "Stolen Base",
        "hit": False,
        "plateAppearance": False
    },
    "stolen_base_2b": {
        "baseRunningEvent": True,
        "description": "Stolen Base 2B",
        "hit": False,
        "plateAppearance": False
    },
    "stolen_base_3b": {
        "baseRunningEvent": True,
        "description": "Stolen Base 3B",
        "hit": False,
        "plateAppearance": False
    },
    "stolen_base_home": {
        "baseRunningEvent": True,
        "description": "Stolen Base Home",
        "hit": False,
        "plateAppearance": False
    },
    "caught_stealing": {
        "baseRunningEvent": False,
        "description": "Caught Stealing",
        "hit": False,
        "plateAppearance": False
    },
    "caught_stealing_2b": {
        "baseRunningEvent": True,
        "description": "Caught Stealing 2B",
        "hit": False,
        "plateAppearance": False
    },
    "caught_stealing_3b": {
        "baseRunningEvent": True,
        "description": "Caught Stealing 3B",
        "hit": False,
        "plateAppearance": False
    },
    "caught_stealing_home": {
        "baseRunningEvent": True,
        "description": "Caught Stealing Home",
        "hit": False,
        "plateAppearance": False
    },
    "defensive_substitution": {
        "baseRunningEvent": False,
        "description": "Defensive Sub",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_caught_stealing_2b": {
        "baseRunningEvent": True,
        "description": "Pickoff Caught Stealing 2B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_caught_stealing_3b": {
        "baseRunningEvent": True,
        "description": "Pickoff Caught Stealing 3B",
        "hit": False,
        "plateAppearance": False
    },
    "pickoff_caught_stealing_home": {
        "baseRunningEvent": True,
        "description": "Pickoff Caught Stealing Home",
        "hit": False,
        "plateAppearance": False
    },
    "balk": {
        "baseRunningEvent": True,
        "description": "Balk",
        "hit": False,
        "plateAppearance": False
    },
    "wild_pitch": {
        "baseRunningEvent": True,
        "description": "Wild Pitch",
        "hit": False,
        "plateAppearance": False
    },
    "other_out": {
        "baseRunningEvent": True,
        "description": "Runner Out",
        "hit": False,
        "plateAppearance": False
    }
}