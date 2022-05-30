# Dictionary mapping each mlb game status abbreviation to details about game status

game_status_map ={
    "FW" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Final: Tie, decision by tiebreaker",
        "reason": "Tied (won in tiebreaker)",
        "abstractGameCode": "F"
    },
    "OW" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Game Over: Tie, decision by tiebreaker",
        "reason": "Tied (won in tiebreaker)",
        "abstractGameCode": "F"
    },
    "MU" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Tag-up play",
        "reason": "Tag-up play",
        "abstractGameCode": "L"
    },
    "MQ" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Rules check",
        "reason": "Rules check",
        "abstractGameCode": "L"
    },
    "NU" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Tag-up play",
        "reason": "Tag-up play",
        "abstractGameCode": "L"
    },
    "NQ" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Rules check",
        "reason": "Rules check",
        "abstractGameCode": "L"
    },
    "OM" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Mercy Rule",
        "reason": "Mercy",
        "abstractGameCode": "F"
    },
    "FM" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Mercy Rule",
        "reason": "Mercy",
        "abstractGameCode": "F"
    },
    "MP" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Home-plate collision",
        "reason": "Home-plate collision",
        "abstractGameCode": "L"
    },
    "NP" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Home-plate collision",
        "reason": "Home-plate collision",
        "abstractGameCode": "L"
    },
    "MF" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Close play at 1st",
        "reason": "Close play at 1st",
        "abstractGameCode": "L"
    },
    "MD" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Catch/drop in outfield",
        "reason": "Catch/drop in outfield",
        "abstractGameCode": "L"
    },
    "NF" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Close play at 1st",
        "reason": "Close play at 1st",
        "abstractGameCode": "L"
    },
    "ND" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Catch/drop in outfield",
        "reason": "Catch/drop in outfield",
        "abstractGameCode": "L"
    },
    "IH" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Instant Replay",
        "reason": "Review",
        "abstractGameCode": "L"
    },
    "S" : {
        "abstractGameState": "Preview",
        "codedGameState": "S",
        "detailedState": "Scheduled",
        "abstractGameCode": "P"
    },
    "P" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Pre-Game",
        "abstractGameCode": "P"
    },
    "PW" : {
        "abstractGameState": "Live",
        "codedGameState": "P",
        "detailedState": "Warmup",
        "abstractGameCode": "L"
    },
    "PR" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Rain",
        "reason": "Rain",
        "abstractGameCode": "P"
    },
    "PS" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Snow",
        "reason": "Snow",
        "abstractGameCode": "P"
    },
    "PG" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "P"
    },
    "PV" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Venue",
        "reason": "Venue",
        "abstractGameCode": "P"
    },
    "PF" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Fog",
        "reason": "Fog",
        "abstractGameCode": "P"
    },
    "PC" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Cold",
        "reason": "Cold",
        "abstractGameCode": "P"
    },
    "PB" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Wind",
        "reason": "Wind",
        "abstractGameCode": "P"
    },
    "PP" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Power",
        "reason": "Power",
        "abstractGameCode": "P"
    },
    "PY" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Ceremony",
        "reason": "Ceremony",
        "abstractGameCode": "P"
    },
    "PL" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "P"
    },
    "PD" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "P"
    },
    "PA" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "P"
    },
    "PO" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start",
        "abstractGameCode": "P"
    },
    "I" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "In Progress",
        "abstractGameCode": "L"
    },
    "IR" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Rain",
        "reason": "Rain",
        "abstractGameCode": "L"
    },
    "IS" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Snow",
        "reason": "Snow",
        "abstractGameCode": "L"
    },
    "IG" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "L"
    },
    "IV" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Venue",
        "reason": "Venue",
        "abstractGameCode": "L"
    },
    "IF" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Fog",
        "reason": "Fog",
        "abstractGameCode": "L"
    },
    "IC" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Cold",
        "reason": "Cold",
        "abstractGameCode": "L"
    },
    "IB" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Wind",
        "reason": "Wind",
        "abstractGameCode": "L"
    },
    "IP" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Power",
        "reason": "Power",
        "abstractGameCode": "L"
    },
    "IY" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Ceremony",
        "reason": "Ceremony",
        "abstractGameCode": "L"
    },
    "IL" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "L"
    },
    "ID" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "L"
    },
    "IA" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "L"
    },
    "IO" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed",
        "abstractGameCode": "L"
    },
    "IZ" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: About to Resume",
        "reason": "About to Resume",
        "abstractGameCode": "L"
    },
    "DR" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Rain",
        "reason": "Rain",
        "abstractGameCode": "F"
    },
    "DS" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Snow",
        "reason": "Snow",
        "abstractGameCode": "F"
    },
    "DG" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "F"
    },
    "DV" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Venue",
        "reason": "Venue",
        "abstractGameCode": "F"
    },
    "DF" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Fog",
        "reason": "Fog",
        "abstractGameCode": "F"
    },
    "DC" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Cold",
        "reason": "Cold",
        "abstractGameCode": "F"
    },
    "DB" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Wind",
        "reason": "Wind",
        "abstractGameCode": "F"
    },
    "DP" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Power",
        "reason": "Power",
        "abstractGameCode": "F"
    },
    "DL" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "F"
    },
    "DD" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "F"
    },
    "DA" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "F"
    },
    "DO" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed",
        "abstractGameCode": "F"
    },
    "CR" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Rain",
        "reason": "Rain",
        "abstractGameCode": "F"
    },
    "CS" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Snow",
        "reason": "Snow",
        "abstractGameCode": "F"
    },
    "CG" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "F"
    },
    "CV" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Venue",
        "reason": "Venue",
        "abstractGameCode": "F"
    },
    "CF" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Fog",
        "reason": "Fog",
        "abstractGameCode": "F"
    },
    "CC" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Cold",
        "reason": "Cold",
        "abstractGameCode": "F"
    },
    "CB" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Wind",
        "reason": "Wind",
        "abstractGameCode": "F"
    },
    "CP" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Power",
        "reason": "Power",
        "abstractGameCode": "F"
    },
    "CL" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "F"
    },
    "CD" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "F"
    },
    "CA" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "F"
    },
    "CO" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled",
        "abstractGameCode": "F"
    },
    "O" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Game Over",
        "abstractGameCode": "F"
    },
    "OR" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Rain",
        "reason": "Rain",
        "abstractGameCode": "F"
    },
    "OS" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Snow",
        "reason": "Snow",
        "abstractGameCode": "F"
    },
    "OG" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "F"
    },
    "OV" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Venue",
        "reason": "Venue",
        "abstractGameCode": "F"
    },
    "OF" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Fog",
        "reason": "Fog",
        "abstractGameCode": "F"
    },
    "OC" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Cold",
        "reason": "Cold",
        "abstractGameCode": "F"
    },
    "OB" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Wind",
        "reason": "Wind",
        "abstractGameCode": "F"
    },
    "OP" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Power",
        "reason": "Power",
        "abstractGameCode": "F"
    },
    "OL" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "F"
    },
    "OD" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "F"
    },
    "OA" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "F"
    },
    "OO" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early",
        "abstractGameCode": "F"
    },
    "F" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Final",
        "abstractGameCode": "F"
    },
    "FR" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Rain",
        "reason": "Rain",
        "abstractGameCode": "F"
    },
    "FS" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Snow",
        "reason": "Snow",
        "abstractGameCode": "F"
    },
    "FG" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "F"
    },
    "FV" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Venue",
        "reason": "Venue",
        "abstractGameCode": "F"
    },
    "FF" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Fog",
        "reason": "Fog",
        "abstractGameCode": "F"
    },
    "FC" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Cold",
        "reason": "Cold",
        "abstractGameCode": "F"
    },
    "FB" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Wind",
        "reason": "Wind",
        "abstractGameCode": "F"
    },
    "FP" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Power",
        "reason": "Power",
        "abstractGameCode": "F"
    },
    "FL" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "F"
    },
    "FD" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "F"
    },
    "FA" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "F"
    },
    "FO" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early",
        "abstractGameCode": "F"
    },
    "UR" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Rain",
        "reason": "Rain",
        "abstractGameCode": "L"
    },
    "US" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Snow",
        "reason": "Snow",
        "abstractGameCode": "L"
    },
    "UG" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "L"
    },
    "UV" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Venue",
        "reason": "Venue",
        "abstractGameCode": "L"
    },
    "UF" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Fog",
        "reason": "Fog",
        "abstractGameCode": "L"
    },
    "UC" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Cold",
        "reason": "Cold",
        "abstractGameCode": "L"
    },
    "UB" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Wind",
        "reason": "Wind",
        "abstractGameCode": "L"
    },
    "UP" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Power",
        "reason": "Power",
        "abstractGameCode": "L"
    },
    "UL" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "L"
    },
    "UA" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "L"
    },
    "UO" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended",
        "abstractGameCode": "L"
    },
    "R" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Final",
        "abstractGameCode": "F"
    },
    "W" : {
        "abstractGameState": "Other",
        "codedGameState": "W",
        "detailedState": "Writing",
        "abstractGameCode": "O"
    },
    "X" : {
        "abstractGameState": "Other",
        "codedGameState": "X",
        "detailedState": "Unknown",
        "abstractGameCode": "O"
    },
    "U" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended",
        "abstractGameCode": "L"
    },
    "RR" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Willful rule violation",
        "reason": "Rule",
        "abstractGameCode": "F"
    },
    "T" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended",
        "abstractGameCode": "L"
    },
    "TR" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Rain",
        "reason": "Rain",
        "abstractGameCode": "L"
    },
    "TS" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Snow",
        "reason": "Snow",
        "abstractGameCode": "L"
    },
    "TG" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Wet Grounds",
        "reason": "Wet Grounds",
        "abstractGameCode": "L"
    },
    "TV" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Venue",
        "reason": "Venue",
        "abstractGameCode": "L"
    },
    "TF" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Fog",
        "reason": "Fog",
        "abstractGameCode": "L"
    },
    "TC" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Cold",
        "reason": "Cold",
        "abstractGameCode": "L"
    },
    "TB" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Wind",
        "reason": "Wind",
        "abstractGameCode": "L"
    },
    "TP" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Power",
        "reason": "Power",
        "abstractGameCode": "L"
    },
    "TL" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Lightning",
        "reason": "Lightning",
        "abstractGameCode": "L"
    },
    "TA" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Tragedy",
        "reason": "Tragedy",
        "abstractGameCode": "L"
    },
    "TO" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended",
        "abstractGameCode": "L"
    },
    "Q" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Game Over",
        "abstractGameCode": "F"
    },
    "QK" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Delay of game ",
        "reason": "Delay",
        "abstractGameCode": "F"
    },
    "QX" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Failure to appear ",
        "reason": "Appear",
        "abstractGameCode": "F"
    },
    "QQ" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Failure to field lineup ",
        "reason": "Lineup",
        "abstractGameCode": "F"
    },
    "QJ" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Ignoring ejection ",
        "reason": "Ejection",
        "abstractGameCode": "F"
    },
    "QI" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Ineligible player ",
        "reason": "Ineligible",
        "abstractGameCode": "F"
    },
    "QN" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Refuses to play ",
        "reason": "Refusal",
        "abstractGameCode": "F"
    },
    "QV" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Unplayable field ",
        "reason": "Unplayable",
        "abstractGameCode": "F"
    },
    "QR" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit: Willful rule violation",
        "reason": "Rule",
        "abstractGameCode": "F"
    },
    "QO" : {
        "abstractGameState": "Final",
        "codedGameState": "Q",
        "detailedState": "Forfeit",
        "abstractGameCode": "F"
    },
    "RK" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Delay of game ",
        "reason": "Delay",
        "abstractGameCode": "F"
    },
    "RX" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Failure to appear ",
        "reason": "Appear",
        "abstractGameCode": "F"
    },
    "RQ" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Failure to field lineup ",
        "reason": "Lineup",
        "abstractGameCode": "F"
    },
    "RJ" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Ignoring ejection ",
        "reason": "Ejection",
        "abstractGameCode": "F"
    },
    "RI" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Ineligible player ",
        "reason": "Ineligible",
        "abstractGameCode": "F"
    },
    "RN" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Refuses to play ",
        "reason": "Refusal",
        "abstractGameCode": "F"
    },
    "RV" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit: Unplayable field ",
        "reason": "Unplayable",
        "abstractGameCode": "F"
    },
    "RO" : {
        "abstractGameState": "Final",
        "codedGameState": "R",
        "detailedState": "Forfeit",
        "abstractGameCode": "F"
    },
    "ME" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Slide interference",
        "reason": "Slide interference",
        "abstractGameCode": "L"
    },
    "NE" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Slide interference",
        "reason": "Slide interference",
        "abstractGameCode": "L"
    },
    "OT" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Game Over: Tied",
        "reason": "Tied",
        "abstractGameCode": "F"
    },
    "UZ" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: About to Resume",
        "reason": "About to Resume",
        "abstractGameCode": "L"
    },
    "FT" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Final: Tied",
        "reason": "Tied",
        "abstractGameCode": "F"
    },
    "PI" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "P"
    },
    "II" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "L"
    },
    "DI" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "F"
    },
    "CI" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "F"
    },
    "OI" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "F"
    },
    "FI" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "F"
    },
    "TI" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "L"
    },
    "UI" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Inclement Weather",
        "reason": "Inclement Weather",
        "abstractGameCode": "L"
    },
    "TU" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Appeal Upheld",
        "reason": "Appeal Upheld",
        "abstractGameCode": "L"
    },
    "UU" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Appeal Upheld",
        "reason": "Appeal Upheld",
        "abstractGameCode": "L"
    },
    "MH" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Home run",
        "reason": "Home run",
        "abstractGameCode": "L"
    },
    "MG" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Grounds rule",
        "reason": "Grounds rule",
        "abstractGameCode": "L"
    },
    "MN" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Fan interference",
        "reason": "Fan interference",
        "abstractGameCode": "L"
    },
    "MS" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Stadium boundary call",
        "reason": "Stadium boundary call",
        "abstractGameCode": "L"
    },
    "MC" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Force play",
        "reason": "Force play",
        "abstractGameCode": "L"
    },
    "MA" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Tag play",
        "reason": "Tag play",
        "abstractGameCode": "L"
    },
    "MO" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Fair/foul in outfield",
        "reason": "Fair/foul in outfield",
        "abstractGameCode": "L"
    },
    "MT" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Trap play in outfield",
        "reason": "Trap play in outfield",
        "abstractGameCode": "L"
    },
    "MI" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Hit by pitch",
        "reason": "Hit by pitch",
        "abstractGameCode": "L"
    },
    "MM" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Timing play",
        "reason": "Timing play",
        "abstractGameCode": "L"
    },
    "MB" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Touching a base",
        "reason": "Touching a base",
        "abstractGameCode": "L"
    },
    "MR" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Passing runners",
        "reason": "Passing runners",
        "abstractGameCode": "L"
    },
    "MK" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Record keeping",
        "reason": "Record keeping",
        "abstractGameCode": "L"
    },
    "ML" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge: Multiple issues",
        "reason": "Multiple issues",
        "abstractGameCode": "L"
    },
    "MX" : {
        "abstractGameState": "Live",
        "codedGameState": "M",
        "detailedState": "Manager challenge",
        "abstractGameCode": "L"
    },
    "NH" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Home run",
        "reason": "Home run",
        "abstractGameCode": "L"
    },
    "NG" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Grounds rule",
        "reason": "Grounds rule",
        "abstractGameCode": "L"
    },
    "NN" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Fan interference",
        "reason": "Fan interference",
        "abstractGameCode": "L"
    },
    "NS" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Stadium boundary call",
        "reason": "Stadium boundary call",
        "abstractGameCode": "L"
    },
    "NC" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Force play",
        "reason": "Force play",
        "abstractGameCode": "L"
    },
    "NA" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Tag play",
        "reason": "Tag play",
        "abstractGameCode": "L"
    },
    "NO" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Fair/foul in outfield",
        "reason": "Fair/foul in outfield",
        "abstractGameCode": "L"
    },
    "NT" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Trap play in outfield",
        "reason": "Trap play in outfield",
        "abstractGameCode": "L"
    },
    "NI" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Hit by pitch",
        "reason": "Hit by pitch",
        "abstractGameCode": "L"
    },
    "NM" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Timing play",
        "reason": "Timing play",
        "abstractGameCode": "L"
    },
    "NB" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Touching a base",
        "reason": "Touching a base",
        "abstractGameCode": "L"
    },
    "NR" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Passing runners",
        "reason": "Passing runners",
        "abstractGameCode": "L"
    },
    "NK" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Record keeping",
        "reason": "Record keeping",
        "abstractGameCode": "L"
    },
    "NL" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review: Multiple issues",
        "reason": "Multiple issues",
        "abstractGameCode": "L"
    },
    "NX" : {
        "abstractGameState": "Live",
        "codedGameState": "N",
        "detailedState": "Umpire review",
        "abstractGameCode": "L"
    },
    "PE" : {
        "abstractGameState": "Preview",
        "codedGameState": "P",
        "detailedState": "Delayed Start: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "P"
    },
    "IE" : {
        "abstractGameState": "Live",
        "codedGameState": "I",
        "detailedState": "Delayed: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "L"
    },
    "DE" : {
        "abstractGameState": "Final",
        "codedGameState": "D",
        "detailedState": "Postponed: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "F"
    },
    "CE" : {
        "abstractGameState": "Final",
        "codedGameState": "C",
        "detailedState": "Cancelled: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "F"
    },
    "OE" : {
        "abstractGameState": "Final",
        "codedGameState": "O",
        "detailedState": "Completed Early: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "F"
    },
    "FE" : {
        "abstractGameState": "Final",
        "codedGameState": "F",
        "detailedState": "Completed Early: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "F"
    },
    "UE" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "L"
    },
    "TE" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: COVID-19",
        "reason": "COVID-19",
        "abstractGameCode": "L"
    },
    "UD" : {
        "abstractGameState": "Live",
        "codedGameState": "U",
        "detailedState": "Suspended: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "L"
    },
    "TD" : {
        "abstractGameState": "Live",
        "codedGameState": "T",
        "detailedState": "Suspended: Air Quality",
        "reason": "Air Quality",
        "abstractGameCode": "L"
    }
}