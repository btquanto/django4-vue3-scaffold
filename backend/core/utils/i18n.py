"""
Utilities related to internationalization
"""
from django.conf import settings
from django.utils import translation


def activate_translation(session):
    """
    Set current language based on the language code stored in session
    """
    language_code = session.get('language', settings.LANGUAGE_CODE)
    language_code = language_code \
        if language_code in ["en", settings.LANGUAGE_CODE] \
        else settings.LANGUAGE_CODE
    translation.activate(language_code)
