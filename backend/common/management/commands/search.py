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
        parser.add_argument("command", nargs="?", type=str)
        parser.add_argument('args', nargs='*', type=str)

    def search_field(self, client, command, args):
        if command == "search_field":
            if len(args) < 3:
                return print("Index, Search field, Value")
            index, field, value, *_ = args
            if index == COMPANY_INDEX:
                _source = ["company_name", "edinet_code", "security_code", "company_address", "industry"]
            elif index == DOCUMENT_INDEX:
                _source = ["material_type", "file_name", "url", "company.edinet_code"]
            client.search(index, {
                "_source": _source,
                "query": {
                    "bool": {
                        "must" : {
                            "match": {
                                field: {
                                    "query": value,
                                }
                            }
                        }
                    }
                },
            })

    def handle(self, *args, command=None, **options):
        client = ElasticSearchClient()
        # client.debug = False
        self.search_field(client, command, args)
