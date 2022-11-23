import { TodoItem } from "../models/todo";
import $fetch from "@/utils/fetch";

const state = {
  todoItems: [],
  formErrors: {},
};

const getters = {
  todoItems: (state) => state.todoItems,
};

const actions = {
  fetchTodoItems: async ({ commit }, data) => {
    const csrf_token = data.csrf_token;
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
  addTodoItem: async ({ commit }, data) => {
    const csrf_token = data.csrf_token;
    const formData = data.formData;
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
  deleteTodoItem: async ({ commit }, data) => {
    const csrf_token = data.csrf_token;
    const item = data.item;
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
  updateTodoItem: async ({ commit }, data) => {
    const csrf_token = data.csrf_token;
    const item = data.item;
    const formData = data.formData;
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

const mutations = {
  setTodoItems: (state, items) => {
    state.todoItems = items;
  },
  addTodoItem: (state, item) => {
    state.todoItems.push(item);
  },
  deleteTodoItem: (state, item) => {
    const idx = state.todoItems.findIndex((obj) => obj.id == item.id);
    if (idx >= 0) {
      state.todoItems.splice(idx, 1);
    }
  },
  updateTodoItem: (state, item) => {
    const idx = state.todoItems.findIndex((obj) => obj.id == item.id);
    if (idx >= 0) {
      state.todoItems.splice(idx, 1, item);
    }
  },
  setFormErrors: (state, errors) => {
    state.formErrors = errors || {};
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
