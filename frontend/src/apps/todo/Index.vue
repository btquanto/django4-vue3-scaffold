<template>
  <MasterLayout />
</template>

<script>
import MasterLayout from "@/components/layout/MasterLayout.vue";

export default {
  name: "TodoIndex",
  components: {
    MasterLayout,
  },
  created() {
    this.$store.dispatch("setup", {
      csrf_token: this.$cookies.get("csrf_token"),
    });
  },
};
</script>
