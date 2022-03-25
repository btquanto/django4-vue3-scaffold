from django.views.generic import TemplateView


class Index(TemplateView):
    template_name = 'vue-app.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['bundle'] = 'todo_index'
        context['$context'] = {
            'message': "Hello World 123"
        }
        return context
