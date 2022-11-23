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
        locale = request.session.get('language', settings.LANGUAGE_CODE)
        response.set_cookie("locale", locale, expires=None, path='/', httponly=False)
        js_context = response.context_data.get('$context', {
            "$title": _("Django App"),
        })
        response.context_data.update({
            "locale": locale,
            "js_context": json.dumps({
                "$context": js_context, # $context passed from django views
                "$global": { } # $global contains attributes that are available to all responses
            })
        })
        return response
