const state = {
  message: "Hello World",
};

const getters = {
  message: (state) => state.message,
};

const actions = {
  updateMessage: ({ commit }, message) => {
    commit("updateMessage", message);
  },
};

const mutations = {
  updateMessage: (state, message) => {
    state.message = message;
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
