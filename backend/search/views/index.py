from django.utils.translation import gettext as _
from django.views.generic import TemplateView


class SearchIndex(TemplateView):
    template_name = 'vue-app.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['bundle'] = 'search_index'
        context['$context'] = {
            '$title': _('Search App')
        }
        return context
