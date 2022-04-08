<template>
  <div className="$relative $flex $min-h-screen $w-full">
    <!-- Side Bar -->
    <SideBar />
    <!-- Body -->
    <div class="$flex $flex-col $grow $min-h-screen">
      <!-- Header -->
      <HeaderBar />
      <!-- Content -->
      <main class="$grow $p-8 $text-cyan-700">
        <RouterView />
      </main>
      <FooterBar />
    </div>
  </div>
</template>

<script>
import "@/assets/css/tailwind.css";

import SideBar from "./SideBar.vue";
import HeaderBar from "./HeaderBar.vue";
import FooterBar from "./FooterBar.vue";
import { RouterView } from "vue-router";

export default {
  name: "MasterLayout",
  components: {
    SideBar,
    HeaderBar,
    FooterBar,
    RouterView,
  },
  mounted() {
    document.title = this.$context.$title;
  },
};
</script>

<style scoped></style>
