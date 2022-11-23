"""
Default middleware that all handles all requests/responses
"""
import json

from django.conf import settings
from django.utils.translation import gettext as _

from core.utils.i18n import activate_translation

class DefaultMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        activate_translation(request.session)
        return self.get_response(request)

    # pylint: disable=no-self-use
    def process_template_response(self, request, response):
        context = response.context_data.get('$context', {
            "$title": _("Django App")
        })
        language_code = request.session.get('language', settings.LANGUAGE_CODE)
        response.context_data['js_context'] = json.dumps({
            "$context": context,
            "$global": {
                '$i18n': {
                    'language_code': language_code,
                },
            }
        })
        return response
