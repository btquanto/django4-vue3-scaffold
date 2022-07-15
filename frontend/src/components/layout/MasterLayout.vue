<template>
  <div className="$relative $flex $min-h-screen $w-full">
    <!-- Side Bar -->
    <SideBar />
    <!-- Body -->
    <div class="$flex $flex-col $grow $min-h-screen">
      <!-- Header -->
      <HeaderBar />
      <!-- Content -->
      <main class="main-container $grow $p-8">
        <RouterView />
      </main>
      <FooterBar />
    </div>
  </div>
</template>

<script>
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
<style lang="css" src="@/assets/css/tailwind.css"></style>
<style lang="scss" src="@/assets/scss/base.scss"></style>
<style scoped lang="scss">
.main-container {
  color: rgb(var(--text-color) / var(--text-opacity));
  flex-grow: 1;
  padding: 2rem;
}
</style>
