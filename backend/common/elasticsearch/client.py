import traceback
from core.network.api_client import APIClient

class ElasticSearchClient(APIClient):
    # pylint: disable=bare-except
    def __init__(self, *, base_url=None):
        if not base_url:
            try:
                # pylint: disable=import-outside-toplevel
                from django.conf import settings
                base_url = settings.ELASTICSEARCH_URL
            except Exception as ex:
                traceback.print_exc()
                print("Cannot find django.conf.settings module")
                raise ex

        super().__init__(base_url=base_url)
        self.debug = False

    def build_headers(self, headers, _endpoint):
        headers['Content-Type'] = 'application/json'
        return headers

    def delete_index(self, index):
        return self.delete(f"/{index}")

    def create_index(self, index, config=None):
        if not config:
            config = {}
        return self.put(f"/{index}", json=config)

    def index_document(self, index, doc):
        return self.post(f"/{index}/_doc", json=doc)

    def search(self, index, query):
        return self.get(f"/{index}/_search", json=query)

    def get_mappings(self, index):
        if not config:
            config = {}
        return self.get(f"/{index}/_mapping", json=config)
