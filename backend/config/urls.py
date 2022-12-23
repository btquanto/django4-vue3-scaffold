"""backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import include, path
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.views.generic.base import RedirectView
from django.views.i18n import JavaScriptCatalog

urlpatterns = [
    path('jsi18n/django', JavaScriptCatalog.as_view(domain="django"), name="jsi18n-django"),
    path('jsi18n/djangojs', JavaScriptCatalog.as_view(domain="djangojs"), name="jsi18n-djangojs"),
    path("", RedirectView.as_view(url="search/", permanent=False), name="default"),
    path('search/', include('search.urls')),
]
# urlpatterns += static(settings.CERT_URL, document_root=settings.CERT_ROOT)
urlpatterns += staticfiles_urlpatterns()
# urlpatterns += static(os.path.join(settings.MEDIA_ROOT), view=serve)