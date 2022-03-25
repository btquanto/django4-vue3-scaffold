<template>
  <div className="$relative $flex $min-h-screen">
    <!-- Side Bar -->
    <SideBar />
    <!-- Body -->
    <div class="$flex-1">
      <!-- Header -->
      <HeaderBar />
      <!-- Content -->
      <main class="$p-8 $text-cyan-700">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<script>
import "@/assets/css/tailwind.css";

import SideBar from "./SideBar.vue";
import HeaderBar from "./HeaderBar.vue";
import { RouterView } from "vue-router";

export default {
  name: "MasterLayout",
  components: {
    SideBar,
    HeaderBar,
    RouterView,
  },
};
</script>

<style scoped></style>
