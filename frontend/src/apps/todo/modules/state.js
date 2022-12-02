export const state = {
  csrf_token: "",
  keyword: "",
  todoItems: [],
  formErrors: {},
};

export const getters = {
  csrf_token: (state) => state.csrf_token,
  todoItems: (state) => state.todoItems,
  keyword: (state) => state.keyword,
  filteredTodoItems: (state) => state.todoItems.filter((item) => item.name.includes(state.keyword)),
};

export const mutations = {
  setState: (state, payload) => {
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
