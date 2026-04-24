"""League and sport identifier mappings for the MLB Stats API."""

SPORT_ID: dict[str, int] = {
    "MLB": 1,
    "LMB": 11,
    "DSL": 16,
    "LIDOM": 17,
    "LMP": 17,
    "LBPRC": 17,
    "VSL": 17,
    "LVBP": 17,
    "SDC": 17,
    "WBCQ": 51,
    "WBC": 51,
}

LEAGUE_ID: dict[str, int] = {
    "MLB": 1,
    "LMB": 125,
    "DSL": 130,
    "LIDOM": 131,
    "LMP": 132,
    "LBPRC": 133,
    "VSL": 134,
    "LVBP": 135,
    "WBCQ": 159,
    "WBC": 160,
    "SDC": 162,
}
