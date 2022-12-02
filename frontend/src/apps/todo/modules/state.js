export const state = {
  csrf_token: "",
  todoItems: [],
  formErrors: {},
};

export const getters = {
  csrf_token: (state) => state.csrf_token,
  todoItems: (state) => state.todoItems,
};

export const mutations = {
  setState: (state, payload) => {
    console.table(payload);
    Object.entries(payload).forEach(([key, value]) => {
      state[key] = value;
    });
  },
  updateStateAttr: (state, { attr, ...payload }) => {
    const attribute = state[attr];
    Object.entries(payload).forEach(([key, value]) => {
      attribute[key] = value;
    });
  },
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
