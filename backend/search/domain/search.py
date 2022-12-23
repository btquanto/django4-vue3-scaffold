from common.elasticsearch.client import ElasticSearchClient

from core.texts.vectorize import USE_vectorize

client = ElasticSearchClient()

def search_value(index, fields, **kwargs):
    search_config = {
        "query": {
            "bool": {
                "must": [
                    {
                        "match": {
                            field: value,
                        },
                    } for field, value in fields.items()
                ],
            },
        },
    }
    for key, value in kwargs.items():
        search_config[key] = value

    return client.search(index, search_config).get("hits", {}).get("hits", [])


def search_knn(index, field, value, **kwargs):
    search_config = {
        "knn": {
            "field": field,
            "k": 5,
            "num_candidates": 5,
            "query_vector": USE_vectorize([value])[0],
        },
    }
    for key, value in kwargs.items():
        search_config[key] = value

    return client.search(index, search_config).get("hits", {}).get("hits", [])
