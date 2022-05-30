def lookupByValue(map, value):
    """
    Lookup the key associated with a value in map.

    :param map: A mapping of keys to values, typically ids to names/descriptions.
    :param type: Dict[Str,Str]
    :param value: A value in map.
    :param type: Str
    """
    if value is None:
        return value
    for k, v in map.items():
        if value in v:
            return k
    raise Exception(f"Key not found! Value: {value}, Map: {map}")