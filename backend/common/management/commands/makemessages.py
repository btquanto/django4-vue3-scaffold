from django.conf import settings
from django.core.management.commands import makemessages

class Command(makemessages.Command):

    def handle(self, *args, **options):
        options['domain'] = 'django'
        options['locale'] = dict(settings.LANGUAGES).keys()
        options['ignore_patterns'] += ['*/.git/*', '*/.virtualenv/*', '*/node_modules/*']
        super().handle(*args, **options)
