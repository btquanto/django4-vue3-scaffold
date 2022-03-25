import { TodoItem } from "../models/todo";

const state = {
  todoItems: [
    new TodoItem({
      name: "Item 1",
      description: "Sample Todo Item",
    }),
    new TodoItem({
      name: "Item 2",
      description: "Sample Todo Item",
    }),
    new TodoItem({
      name: "Item 3",
      description: "Sample Todo Item",
    }),
    new TodoItem({
      name: "Item 4",
      description: "Sample Todo Item",
    }),
    new TodoItem({
      name: "Item 5",
      description: "Sample Todo Item",
    }),
  ],
};

const getters = {
  todoItems: (state) => state.todoItems,
};

const actions = {
  addTodoItem: async ({ commit }, data) => {
    commit("addTodoItem", new TodoItem(data));
  },
  removeTodoItem: async ({ commit }, item) => {
    commit("removeTodoItem", item);
  },
};

const mutations = {
  addTodoItem: (state, item) => {
    state.todoItems.push(item);
  },
  removeTodoItem: (state, item) => {
    const idx = state.todoItems.findIndex((obj) => obj == item);
    if (idx >= 0) {
      state.todoItems.splice(idx, 1);
    }
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
