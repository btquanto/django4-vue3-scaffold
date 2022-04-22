import moment from "moment";

const JS_DATA = window.JS_DATA || {};

export default {
  install(app, _options) {
    app.config.globalProperties.$log = (...args) => console.log(...args);
    // Global constants
    app.config.globalProperties.$path = encodeURIComponent(location.pathname);
    app.config.globalProperties.$url = new URL(location.href);
    app.config.globalProperties.$moment = (...args) => moment(...args);
    app.config.globalProperties.$context = JS_DATA.$context;
    app.config.globalProperties.$global = JS_DATA.$global;
  },
};
