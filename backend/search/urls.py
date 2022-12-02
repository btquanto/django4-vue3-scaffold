"""
Module url configurations
"""
from django.urls import path
from .views import index

urlpatterns = [
    # Dashboard
    path('', index.SearchIndex.as_view(), name='index'),
]
