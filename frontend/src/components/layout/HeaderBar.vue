<template>
  <header class="$bg-white $shadow $px-1 $py-4">
    <button class="$text-cyan-600" @click="$store.dispatch('toggleSidebar')">
      <MenuIcon class="$h-6 $w-6" />
    </button>
  </header>
</template>

<script>
import { MenuIcon } from "@heroicons/vue/solid";

export default {
  name: "HeaderBar",
  components: {
    MenuIcon,
  },
  computed: {},
  created() {},
};
</script>

<style scoped></style>
