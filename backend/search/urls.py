"""
Module url configurations
"""
from django.urls import path
from .views import search

urlpatterns = [
    # Dashboard
    path('', search.SearchIndex.as_view(), name="index"),
    path('api/document/query', search.search_document, name="api-document"),
    path('api/document/knn', search.knn_search_document, name="api-document-knn"),
    path('api/company/query', search.search_company, name="api-search-company"),
]
