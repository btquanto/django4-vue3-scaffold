import os
from django.core.management.base import BaseCommand
from common.elasticsearch.client import ElasticSearchClient

ELASTIC_DATA_DIR = os.path.abspath(os.path.join(os.getcwd(), "..", "_elastic"))

COMPANY_INDEX = "company"
COMPANY_INDEX_CONFIG = "configs/company.json"

DOCUMENT_INDEX = "document"
DOCUMENT_INDEX_CONFIG = "configs/document.json"

DOCS_DIR = os.path.join(ELASTIC_DATA_DIR, "docs")


class Command(BaseCommand):
    help = "ElasticSearch commands"

    def add_arguments(self, parser):
        parser.add_argument('args', nargs='*', type=str)

    def search_company(self, client, field, value):
        return client.search(COMPANY_INDEX, {
            "_source": ["company_name", "edinet_code", "security_code", "company_address", "industry"],
            "query": {
                "bool": {
                    "must": {
                        "match": {
                            field: {
                                "query": value,
                            },
                        },
                    },
                },
            },
        })

    def search_document(self, client, field, value):
        return client.search(DOCUMENT_INDEX, {
            "_source": ["material_type", "file_name", "url", "company.edinet_code"],
            "query": {
                "bool": {
                    "must": {
                        "match": {
                            field: {
                                "query": value,
                            },
                        },
                    },
                },
            },
            "collapse": {
                "field": "company.edinet_code"
            },
        })

    def knn_search_document(self, client, field, value):
        # pylint: disable=import-outside-toplevel
        from core.texts.vectorize import USE_vectorize
        return client.search(DOCUMENT_INDEX, {
            "_source": ["material_type", "file_name", "url", "company.edinet_code"],
            "knn": {
                "field": field,
                "k": 5,
                "num_candidates": 5,
                "query_vector": USE_vectorize(value)[0],
            },
            "collapse": {
                "field": "company.edinet_code"
            },
        })

    def handle(self, *args, **options):
        client = ElasticSearchClient()
        if len(args) < 3:
            print("Index, Search field, Value")
            return
        index, field, value, *_ = args
        if index == COMPANY_INDEX:
            self.search_company(client, field, value)
        elif index == DOCUMENT_INDEX:
            if field in ["content_vector"]:
                self.knn_search_document(client, field, value)
            else:
                self.search_document(client, field, value)
