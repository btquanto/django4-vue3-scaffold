"""
Module url configurations
"""
from django.urls import path
from .views import index

urlpatterns = [
    # Dashboard
    path('', index.Index.as_view(), name='index'),
    path('api/todo-item/add', index.api_add_todo_item, name="api-add-todo-item"),
    path('api/todo-item/fetch', index.api_fetch_todo_items, name="api-fetch-todo-items"),
    path('api/todo-item/delete/<int:pk>', index.api_delete_todo_item, name="api-delete-todo-item"),
    path('api/todo-item/update/<int:pk>', index.api_update_todo_item, name="api-update-todo-item"),
]
