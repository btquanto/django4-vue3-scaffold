import json
import requests

class APIClient(object):

    def __init__(self, *, base_url=None, **_):
        self.base_url = base_url
        self.debug = False

    def log(self, *args, **kwargs):
        if self.debug:
            print(*args, **kwargs)

    def build_headers(self, headers, _endpoint):
        # Additional control over headers
        return headers

    def build_request(self, endpoint, **kwargs):
        extras = dict(headers={
            'Accept': 'application/json',
            'Accept-Language': 'en_US',
        })
        self.build_headers(extras['headers'], endpoint)
        extras['url'] = f"{self.base_url}{endpoint}"
        extras.update(kwargs)
        return extras

    def call(self, method, url, **kwargs):
        func = {
            'get': requests.get,
            'post': requests.post,
            'patch': requests.patch,
            'put': requests.put,
            'delete': requests.delete,
        }.get(method.lower())
        kwargs = self.build_request('', **kwargs)
        kwargs['url'] = url
        response = func(**kwargs)
        self.log(method, url)
        self.log(json.dumps(response.json(), ensure_ascii=False, indent=2))
        return response

    def get(self, endpoint, params=None, **kwargs):
        if not params:
            params = {}
        params = "&".join(map(lambda o : f"{o[0]}={o[1]}", params.items()))
        if params:
            endpoint = f"{endpoint}?{params}"
        return self.call('get', f"{self.base_url}{endpoint}", **kwargs)

    def post(self, endpoint, **kwargs):
        return self.call('post', f"{self.base_url}{endpoint}", **kwargs)

    def patch(self, endpoint, **kwargs):
        return self.call('patch', f"{self.base_url}{endpoint}", **kwargs)

    def put(self, endpoint, **kwargs):
        return self.call('put', f"{self.base_url}{endpoint}", **kwargs)

    def delete(self, endpoint, **kwargs):
        return self.call('delete', f"{self.base_url}{endpoint}", **kwargs)
