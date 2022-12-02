import { createApp } from "vue";
import { Store } from "vuex";
import { createRouter, createWebHashHistory } from "vue-router";

import common from "@/utils/plugins/common";
import VueCookies from "vue-cookies";
import gettext from "@/utils/i18n";
import layout from "@/modules/layout";
import todo from "@/apps/todo/modules";

import Index from "@/apps/todo/Index.vue";
import TodoList from "@/apps/todo/TodoList.vue";
import TodoItemForm from "@/apps/todo/TodoItemForm.vue";

const routes = [
  { path: "/", component: TodoList },
  { path: "/add", component: TodoItemForm },
  { path: "/edit/:id", component: TodoItemForm },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

const store = new Store({
  modules: {
    layout,
    todo,
  },
});

const app = createApp(Index);
app.use(gettext);
app.use(router);
app.use(store);
app.use(common);
app.use(VueCookies);
app.mount("#app");
