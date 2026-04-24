"""Field and flag constants for the people scraper."""

PEOPLE_META: list[str] = [
    "id", "fullName", "link", "firstName", "lastName", "birthDate", "currentAge",
    "birthCity", "birthStateProvince", "birthCountry", "height", "weight", "active",
    "useName", "middleName", "boxscoreName", "nameFirstLast", "nameSlug",
    "firstLastName", "lastFirstName", "lastInitName", "initLastName", "fullFMLName",
    "fullLFMName", "strikeZoneTop", "strikeZoneBottom",
]

PEOPLE_PRIMARY_POSITION: list[str] = ["abbreviation"]
PEOPLE_BAT_SIDE: list[str] = ["batSideCode"]
PEOPLE_PITCH_HAND: list[str] = ["pitchHandCode"]

PEOPLE_META_FLAG = "meta"
PEOPLE_PRIMARY_POSITION_FLAG = "primaryPosition"
PEOPLE_BAT_SIDE_FLAG = "batSide"
PEOPLE_PITCH_HAND_FLAG = "pitchHand"
