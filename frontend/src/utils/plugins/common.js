import moment from "moment";

const $JS_CONTEXT = window.$JS_CONTEXT || {};

export default {
  install(app, _options) {
    app.config.globalProperties.$log = (...args) => console.log(...args);
    // Global constants
    app.config.globalProperties.$path = encodeURIComponent(location.pathname);
    app.config.globalProperties.$url = new URL(location.href);
    app.config.globalProperties.$moment = (...args) => moment(...args);
    app.config.globalProperties.$context = $JS_CONTEXT.$context;
    app.config.globalProperties.$global = $JS_CONTEXT.$global;
  },
};
