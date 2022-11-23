import { TodoItem } from "../models/todo";
import $fetch from "@/utils/fetch";

export default {
  fetchTodoItems: async ({ commit, getters }) => {
    const csrf_token = getters.csrf_token;
    const [res, error] = await $fetch("/todo/api/todo-item/fetch", {
      method: "get",
      headers: {
        "X-CSRFToken": csrf_token,
      },
    });
    if (res) {
      if (res.success) {
        const items = res.data.map((item) => new TodoItem(item));
        commit("setTodoItems", items);
      }
    }
    return [res, error];
  },
  addTodoItem: async ({ commit, getters }, { formData }) => {
    const csrf_token = getters.csrf_token;
    const [res, error] = await $fetch("/todo/api/todo-item/add", {
      method: "post",
      headers: {
        "X-CSRFToken": csrf_token,
      },
      body: formData,
    });
    if (res) {
      if (res.success) {
        const item = new TodoItem(res.data);
        commit("addTodoItem", item);
      } else {
        commit("setFormErrors", res.errors);
      }
    }
    return [res, error];
  },
  deleteTodoItem: async ({ commit, getters }, item) => {
    const csrf_token = getters.csrf_token;
    const [res, error] = await $fetch(`/todo/api/todo-item/delete/${item.id}`, {
      method: "post",
      headers: {
        "X-CSRFToken": csrf_token,
      },
    });
    if (res && res.success) {
      commit("deleteTodoItem", item);
    }
    return [res, error];
  },
  updateTodoItem: async ({ commit, getters }, { item, formData }) => {
    const csrf_token = getters.csrf_token;
    const [res, error] = await $fetch(`/todo/api/todo-item/update/${item.id}`, {
      method: "post",
      headers: {
        "X-CSRFToken": csrf_token,
      },
      body: formData,
    });
    if (res) {
      if (res.success) {
        const item = new TodoItem(res.data);
        commit("updateTodoItem", item);
      } else {
        commit("setFormErrors", res.errors);
      }
    }
    return [res, error];
  },
};
