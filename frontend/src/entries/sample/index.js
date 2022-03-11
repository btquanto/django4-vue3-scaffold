import Vuex from "vuex";
import { createApp } from "vue";
import common from "@/utils/plugins/common";
import sample from "@/modules/sample";
import App from "@/apps/sample/Index.vue";

const store = new Vuex.Store({
  modules: {
    sample,
  },
});

const app = createApp(App);
app.use(store);
app.use(common);
app.mount("#app");
