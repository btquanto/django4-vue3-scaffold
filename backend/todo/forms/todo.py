from django import forms

from ..models.todo import TodoItem


class TodoItemFormMixin:

    def clean(self):
        cleaned_data = super().clean()
        return cleaned_data


class AddTodoItemForm(TodoItemFormMixin, forms.ModelForm):

    class Meta:
        model = TodoItem
        fields = ("name", "description", "priority")
