# System-level imports
# Framework-level imports
from django.http import HttpResponseNotAllowed, JsonResponse
from django.views.generic import TemplateView

# Project-level imports
from core.utils.proxy import deproxify
from core.utils.serializers import jsonify

# Module-level imports
from ..forms.todo import AddTodoItemForm
from ..models import TodoItem


class Index(TemplateView):
    template_name = 'vue-app.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['bundle'] = 'todo_index'
        context['$context'] = {
            'message': "Hello World 123"
        }
        return context


def api_add_todo_item(request):
    if request.method != 'POST':
        return HttpResponseNotAllowed(['POST'])

    form = AddTodoItemForm(request.POST)

    if form.is_valid():
        item = form.save()

        return JsonResponse({
            "success": True,
            "data": jsonify([item])[0]
        })
    return JsonResponse({
        "success": False,
        "errors": deproxify(form.errors)
    })

def api_fetch_todo_items(request):
    if request.method != 'GET':
        return HttpResponseNotAllowed(['GET'])

    return JsonResponse({
        "success": True,
        "data": jsonify(TodoItem.objects.all())
    })


def api_delete_todo_item(request, pk):
    if request.method != 'POST':
        return HttpResponseNotAllowed(['POST'])
    
    TodoItem.objects.filter(pk=pk).delete()

    return JsonResponse({
        "success": True,
    })
