"""Field and flag constants for the transactions scraper."""

TRANSACTIONS_META: list[str] = [
    "id", "transactionDate", "effectiveDate", "resolutionDate", "typeCode", "typeDesc", "description",
]
TRANSACTIONS_PERSON_ID: list[str] = ["personId"]
TRANSACTIONS_TO_TEAM_ID: list[str] = ["toTeamId"]
TRANSACTIONS_TEAM_ID: list[str] = ["teamId"]

TRANSACTIONS_META_FLAG = "meta"
TRANSACTIONS_PERSON_FLAG = "person"
TRANSACTIONS_TO_TEAM_FLAG = "toTeam"
