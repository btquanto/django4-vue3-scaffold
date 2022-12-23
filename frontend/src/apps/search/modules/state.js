export const state = {
  csrf_token: "",
  companies: [],
  documents: [],
};

export const getters = {
  csrf_token: (state) => state.csrf_token,
  companies: (state) => state.companies,
  documents: (state) => state.documents,
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
};
