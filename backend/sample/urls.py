"""
Module url configurations
"""
from django.urls import path
from .views import index

urlpatterns = [
    # Dashboard
    path('', index.Index.as_view(), name='index'),
]
