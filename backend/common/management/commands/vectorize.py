from django.core.management.base import BaseCommand
from core.texts.vectorize import USE_vectorize

class Command(BaseCommand):
    help = "ElasticSearch commands"

    def add_arguments(self, parser):
        parser.add_argument("text", nargs="?", type=str)

    def handle(self, *args, text=None, **options):
        if text:
            print(USE_vectorize(text)[0])
