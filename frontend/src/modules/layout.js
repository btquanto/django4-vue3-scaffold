const state = {
  showSidebar: window.innerWidth >= 720,
};

const getters = {
  showSidebar: (state) => state.showSidebar,
};

const actions = {
  toggleSidebar: ({ state, commit }) => {
    commit("setSidebarVisibility", !state.showSidebar);
  },
};

const mutations = {
  setSidebarVisibility: (state, showSidebar) => {
    state.showSidebar = showSidebar;
  },
};

export default {
  state,
  getters,
  actions,
  mutations,
};
