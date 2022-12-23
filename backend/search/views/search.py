import os
import json
import fitz

from django.http import JsonResponse
from django.utils.translation import gettext as _
from django.views.generic import TemplateView

from core.texts.literal import has_meaning
from core.texts.splittext import split_paragraph

from ..domain.search import search_value, search_knn


DOCUMENT_INDEX = "document"
DOCUMENT_SOURCES = [
    "type",
    "file_name",
    "url",
    "content",
    "company.edinet_code",
    "company.security_code",
    "company.company_name",
    "company.company_address",
    "company.industry",
    "company.balance_sheet_url",
    "company.consolidated_balance_sheet_url",
    "company.profit_loss_url",
    "company.consolidated_profit_loss_url",
    "company.meeting_explanatory_materials_url",
    "company.growth_potential_materials_url",
]

COMPANY_INDEX = "company"
COMPANY_SOURCES = [
    "edinet_code",
    "security_code",
    "company_name",
    "company_address",
    "industry",
    "balance_sheet_url",
    "consolidated_balance_sheet_url",
    "profit_loss_url",
    "consolidated_profit_loss_url",
    "meeting_explanatory_materials_url",
    "growth_potential_materials_url",
    "materials.type",
    "materials.file_name",
    "materials.url",
]


class SearchIndex(TemplateView):
    template_name = 'vue-app.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['bundle'] = 'search_index'
        context['$context'] = {
            '$title': _('Search')
        }
        return context


def search_document(request):
    """
        Search documents by text values
        Supported fields: type, file_name, content, url, company.edinet_code, comnpany.company_name, company.company_address, company.industry, company.security_code
        {
            "fields": {
                "content":  "力から脅威を受けたり被害を受けたりするおそれのある場合には、組織全体として速やかに対処できる体制を整備しております。"
                "type": "growth_potential"
            },
        }
    """
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method"}, status=400)

    body = json.loads(request.body)
    fields = body.get("fields")
    results = search_value(DOCUMENT_INDEX, fields, _source=DOCUMENT_SOURCES, collapse={"field": "company.edinet_code"})

    return JsonResponse({
        "success": True,
        "data": results
    })


def knn_search_document(request):
    """
        Search with knn search
    """
    if request.method != "POST":
        return JsonResponse({"message": "Invalid method"}, status=400)

    upload = request.FILES.get("file")

    if not upload:
        return JsonResponse({"message": "File not found"}, status=400)

    _, ext = os.path.splitext(upload.name)
    if ext != ".pdf":
        return JsonResponse({"message": "Invalid file type"}, status=400)

    sentences = []
    with fitz.open(upload) as doc:
        for page in doc:
            content = page.get_text()
            sentences.extend(filter(has_meaning, map(str.strip, split_paragraph(content))))

    document = "".join(sentences)
    results = search_knn(DOCUMENT_INDEX, "content_vector", document, _source=DOCUMENT_SOURCES, collapse={"field": "company.edinet_code"})

    return JsonResponse({
        "success": True,
        "data": results
    })


def search_company(request):
    """
        Search company by text values
        Supported fields: edinet_code, company_name, company_address, industry, security_code
        {
            "fields": {
                "company_name":  "fixer"
                "company_address": "Tokyo"
            },
        }
    """
    if request.method != "POST":
        return JsonResponse({"success": False, "message": "Invalid method"}, status=400)

    body = json.loads(request.body)
    fields = body.get("fields")
    results = search_value(COMPANY_INDEX, fields, _source=COMPANY_SOURCES)

    return JsonResponse({
        "success": True,
        "data": results
    })
