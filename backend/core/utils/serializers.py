"""
Utilities to serialize a model object
"""
import json

from django.core import serializers

json_serializer = serializers.get_serializer("json")()

def _flatten(model):
    data = model['fields']
    data.update({
        'id': model['pk']
    })

    return data

# pylint: disable=dangerous-default-value
# pylint: disable=line-too-long
def jsonify(models, * , one_to_one_fields=[], one_to_many_fields=[], properties=[]):
    """Turning a query or a list of models into a json

    Args:
        models ([Model] | Query): The list or query of the models to jsonify
        one_to_one_fields ([str], optional): A list of one-to-one fields that would also be jsonified. Defaults to [].
        one_to_many_fields ([str], optional): A list of one-to-many fields that would also be jsonified. Defaults to [].
        properties ([str], optional): A list of properties that would be included. Defaults to [].

    Returns:
        [dict]: A list of jsonified models
    """
    jmodels = json.loads(json_serializer.serialize(models)) if models else []
    if jmodels and (one_to_one_fields or one_to_many_fields or properties):
        for jmodel, model in zip(jmodels, models):
            for key in one_to_one_fields:
                obj = getattr(model, key, None)
                jmodel['fields'][key] = jsonify([obj])[0] if obj else None
            for key in one_to_many_fields:
                obj = getattr(model, key, None)
                if obj and hasattr(obj, '__iter__'):
                    jmodel['fields'][key] = jsonify(obj) if obj else []
                else:
                    jmodel['fields'][key] = jsonify(obj.all()) if obj else []
            for key in properties:
                jmodel['fields'][key] = getattr(model, key, None)
    return [ _flatten(jmodel) for jmodel in jmodels]
