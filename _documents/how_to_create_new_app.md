# How to create new app

## Create new Django app

Assuming we want to create a new app named `myapp`, here are the steps we must follow:

1. Create a new directory named `myapp` in `backend` directory.
2. Create a new `myapp.views` module and write your fist view as followed.

  ```python
  from django.utils.translation import gettext as _
  from django.views.generic import TemplateView

  class MyAppIndex(TemplateView):
      template_name = 'vue-app.html'

      def get_context_data(self, **kwargs):
          context = super().get_context_data(**kwargs)
          context['bundle'] = 'myapp_index' # This is defined in `vue.config.js`
          context['$context'] = {
              '$title': _('My App')
          }
          return context
  ```

3. Create a new `myapp.urls` module and write your first URL as followed.

  ```python
  from django.urls import path
  from .views import MyAppIndex

  urlpatterns = [
      path('', MyAppIndex.as_view(), name='index'),
  ]
  ```

4. Add `myapp` to `INSTALLED_APPS` in `backend/config/settings.py` as followed.

  ```python
  INSTALLED_APPS = [
      # Default apps
      'django.contrib.admin',
      'django.contrib.auth',
      'django.contrib.contenttypes',
      'django.contrib.sessions',
      'django.contrib.messages',
      'django.contrib.staticfiles',
      # Third-party apps
      'core.plugins.webpack_loader',
      # Local apps
      'common',
      'myotherapps',
      ...
      'myapp', # <== Your new app
  ]
  ```

5. Add `myapp.urls` to `backend/config/urls.py` as followed.

  ```python
  from django.urls import include, path
  from django.contrib.staticfiles.urls import staticfiles_urlpatterns

  urlpatterns = [
      ....
      path('myapp/', include('myapp.urls')), # <== Your new app urls
  ]
  urlpatterns += staticfiles_urlpatterns()
  ```

## Create new VueJs app

1. Create a new directory named `myapp` in `frontend/src/apps` directory.
2. Create your app's entry view file in `frontend/src/apps/myapp`, for example `MyAppIndex.vue`.
3. Create an entrypoint for `myapp` in `frontend/src/entries/myapp`, for example `index.js`, as followed.

  ```javascript
  import Vue from 'vue'
  import MyAppIndex from '@/apps/myapp/MyAppIndex.vue'

  const app = createApp(MyAppIndex);
  app.mount("#app");
  ```

4. Add `myapp` to the `APPS` constant defined in `frontend/vue.config.js`, for example.

  ```javascript
  const APPS = {
    myapp: {
      index: { entry: `./frontend/src/entries/myapp/index.js` }, // Path to your entry point file
    },
  };
  ```

5. Rebuild your vue app.

  ```bash
  $ ./cmd yarn build
  ```
