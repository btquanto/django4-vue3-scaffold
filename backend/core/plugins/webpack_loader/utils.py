from importlib import import_module
from django.conf import settings
from .config import load_config

_loaders = {}


def import_string(dotted_path):
    '''
    This is a rough copy of django's import_string, which wasn't introduced until Django 1.7

    Once this package's support for Django 1.6 has been removed, this can be safely replaced with
    `from django.utils.module_loading import import_string`
    '''
    try:
        module_path, class_name = dotted_path.rsplit('.', 1)
        module = import_module(module_path)
        return getattr(module, class_name)
    except (ValueError, AttributeError, ImportError) as exc:
        exc.msg = f'{dotted_path} doesn\'t look like a valid module path'
        raise exc


def get_loader(config_name):
    if config_name not in _loaders:
        config = load_config(config_name)
        loader_class = import_string(config['LOADER_CLASS'])
        _loaders[config_name] = loader_class(config_name, config)
    return _loaders[config_name]


def get_skip_common_chunks(config_name):
    loader = get_loader(config_name)
    # The global default is currently False, whenever that is changed, change
    # this fallback value as well which is present to provide backwards
    # compatibility.
    return loader.config.get('SKIP_COMMON_CHUNKS', False)


def _filter_by_extension(bundle, extension):
    '''Return only files with the given extension'''
    for chunk in bundle:
        if chunk['name'].endswith('.{0}'.format(extension)):
            yield chunk


def _get_bundle(loader, bundle_name, extension):
    bundle = loader.get_bundle(bundle_name)
    if extension:
        bundle = _filter_by_extension(bundle, extension)
    return bundle


def get_files(bundle_name, extension=None, config='DEFAULT'):
    '''Returns list of chunks from named bundle'''
    loader = get_loader(config)
    return list(_get_bundle(loader, bundle_name, extension))


def get_as_tags(bundle_name, extension=None, config='DEFAULT', suffix='', attrs='', is_preload=False):
    '''
    Get a list of formatted <script> & <link> tags for the assets in the
    named bundle.

    :param bundle_name: The name of the bundle
    :param extension: (optional) filter by extension, eg. 'js' or 'css'
    :param config: (optional) the name of the configuration
    :return: a list of formatted tags as strings
    '''

    loader = get_loader(config)
    bundle = _get_bundle(loader, bundle_name, extension)
    tags = []

    for chunk in bundle:
        href = ''.join([chunk['url'], suffix])
        integrity_attr = loader.get_integrity_attr(chunk)
        if chunk['name'].endswith(('.js', '.js.gz')):
            if is_preload:
                tags.append(f'''<link rel="preload" as="script" href="{href}" {attrs}/>''')
            else:
                tags.append(f'''<script src="{href}"{integrity_attr}{attrs}></script>''')
        elif chunk['name'].endswith(('.css', '.css.gz')):
            rel = '"stylesheet"' if not is_preload else '"preload" as="style"'
            tags.append(f'''<link href="{href}" rel={rel}{integrity_attr}{attrs}/>''')
    return tags


def get_static(asset_name, config='DEFAULT'):
    '''
    Equivalent to Django's 'static' look up but for webpack assets.

    :param asset_name: the name of the asset
    :param config: (optional) the name of the configuration
    :return: path to webpack asset as a string
    '''
    public_path = get_loader(config).get_assets().get('publicPath', getattr(settings, 'STATIC_URL'))
    return f"{public_path}{asset_name}"
