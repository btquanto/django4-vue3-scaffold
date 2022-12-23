import { createApp } from "vue";
import { Store } from "vuex";
import { createRouter, createWebHashHistory } from "vue-router";

import common from "@/utils/plugins/common";
import VueCookies from "vue-cookies";
import gettext from "@/utils/i18n";
import layout from "@/modules/layout";
import search from "@/apps/search/modules";

import Index from "@/apps/search/Index.vue";
import SearchView from "@/apps/search/SearchView.vue";

const routes = [{ path: "/", component: SearchView }];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

const store = new Store({
  modules: {
    layout,
    search,
  },
});

const app = createApp(Index);
app.use(gettext);
app.use(router);
app.use(store);
app.use(common);
app.use(VueCookies);
app.mount("#app");
