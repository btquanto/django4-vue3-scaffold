"""
Default middleware that all handles all requests/responses
"""
import json

from django.conf import settings
from django.middleware.csrf import get_token as get_csrf_token

from core.utils.i18n import activate_translation

class DefaultMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        activate_translation(request.session)
        return self.get_response(request)

    # pylint: disable=no-self-use
    def process_template_response(self, request, response):
        js_data = json.dumps({
            "$context": response.context_data.get('$context', {}),
            "$global": {
                '$i18n': {
                    'language_code': request.session.get('language', settings.LANGUAGE_CODE),
                },
                "csrf_token": get_csrf_token(request)
            }
        })

        response.context_data['js_data'] = js_data
        return response
