def unpack(value):
    if isinstance(value, (list, dict)):
        return deproxify(value)
    if isinstance(value, (str, int, float, bool, type(None))):
        return value
    return str(value)


def deproxify(obj):
    if isinstance(obj, dict):
        return { key: unpack(value) for key, value in obj.items()}

    if isinstance(obj, list):
        return [unpack(value) for value in obj]

    return obj
