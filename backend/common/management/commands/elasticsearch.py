import os
import json
import curses
import urllib.parse
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

    def init(self, client, command):
        if command == "init":
            company_config_path = os.path.join(ELASTIC_DATA_DIR, COMPANY_INDEX_CONFIG)
            if not os.path.exists(company_config_path):
                return print(f"Missing company index config file `{COMPANY_INDEX_CONFIG}`")

            document_config_path = os.path.join(ELASTIC_DATA_DIR, DOCUMENT_INDEX_CONFIG)
            if not os.path.exists(document_config_path):
                return print(f"Missing document index config file {DOCUMENT_INDEX_CONFIG}")

            with open(company_config_path, "r", encoding="utf8") as fp:
                company_config = json.load(fp)
                client.delete_index(COMPANY_INDEX)
                client.create_index(COMPANY_INDEX, company_config)

            with open(document_config_path, "r", encoding="utf8") as fp:
                document_config = json.load(fp)
                client.delete_index(DOCUMENT_INDEX)
                client.create_index(DOCUMENT_INDEX, document_config)

    def index_data(self, client, command):
        stdscr = curses.initscr()
        curses.noecho()
        curses.cbreak()
        try:
            client.debug = False
            if command == "index_data":
                company_doc_dir = os.path.join(DOCS_DIR, "company")
                document_doc_dir = os.path.join(DOCS_DIR, "document")

                if os.path.exists(company_doc_dir):
                    files = os.listdir(company_doc_dir)
                    count = len(files)
                    for idx, file in enumerate(files):
                        
                        file_path = os.path.join(company_doc_dir, file)
                        with open(file_path, "r", encoding="utf8") as fp:
                            response = client.index_document(COMPANY_INDEX, json.load(fp))
                            stdscr.addstr(0, 0, f"Indexing { (idx + 1) * 100 / count : .2f}%")
                            stdscr.addstr(1, 0, json.dumps(response.json()))
                            stdscr.refresh()

                if os.path.exists(document_doc_dir):
                    files = os.listdir(document_doc_dir)
                    count = len(files)
                    for idx, file in enumerate(files):
                        file_path = os.path.join(document_doc_dir, file)
                        with open(file_path, "r", encoding="utf8") as fp:
                            response = client.index_document(DOCUMENT_INDEX, json.load(fp))
                            stdscr.addstr(0, 0, f"Indexing { (idx + 1) * 100 / count : .2f}%")
                            stdscr.addstr(1, 0, json.dumps(response.json()))
                            stdscr.refresh()
        finally:
            curses.echo()
            curses.nocbreak()
            curses.endwin()

    def clean_data(self, command):
        if command == "clean_data":
            document_doc_dir = os.path.join(DOCS_DIR, "document")

            if os.path.exists(document_doc_dir):
                files = os.listdir(document_doc_dir)
                count = len(files)
                for idx, file in enumerate(files):
                    print(f"Cleaning { (idx + 1) * 100 / count : .2f}%", end="\r", flush=True)
                    file_path = os.path.join(document_doc_dir, file)
                    data = {}
                    with open(file_path, "r", encoding="utf8") as fp:
                        data = json.load(fp)
                    if data:
                        file_name = urllib.parse.quote(data['file_name'])
                        if data["type"] == "growth_potential":
                            base_url = data["company"]["growth_potential_materials_url"].replace("https://console.cloud.google.com/storage/browser/", "https://storage.cloud.google.com/")
                            data["url"] = f"{base_url}/{file_name}"
                        elif data["type"] == "explanatory":
                            base_url = data["company"]["meeting_explanatory_materials_url"].replace("https://console.cloud.google.com/storage/browser/", "https://storage.cloud.google.com/")
                            data["url"] = f"{base_url}/{file_name}"
                        with open(file_path, "w", encoding="utf8") as fp:
                            json.dump(data, fp, ensure_ascii=False, indent=2)

    def handle(self, *args, command=None, **options):
        client = ElasticSearchClient()
        # client.debug = False
        self.init(client, command)
        self.index_data(client, command)
        # self.clean_data(command)
