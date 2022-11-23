import { state, getters, mutations } from "./state";

const actions = {
  setup: async ({ commit }, { ...stateAttributes }) => {
    commit("setState", {
      ...stateAttributes,
    });
  },
  ...require("./actions").default,
};

export default {
  state,
  getters,
  actions,
  mutations,
};
