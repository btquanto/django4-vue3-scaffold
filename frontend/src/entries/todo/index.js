import { createApp } from "vue";
import { Store } from "vuex";
import { createRouter, createWebHashHistory } from "vue-router";

import common from "@/utils/plugins/common";
import layout from "@/modules/layout";
import todo from "@/apps/todo/modules/todo";

import MasterLayout from "@/components/layout/MasterLayout.vue";
import TodoList from "@/apps/todo/TodoList.vue";
import AddTodoItem from "@/apps/todo/AddTodoItem.vue";
import EditTodoItem from "@/apps/todo/EditTodoItem.vue";

const routes = [
  { path: "/", component: TodoList },
  { path: "/add", component: AddTodoItem },
  { path: "/edit/:id", component: EditTodoItem },
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

const app = createApp(MasterLayout);
app.use(router);
app.use(store);
app.use(common);
app.mount("#app");
