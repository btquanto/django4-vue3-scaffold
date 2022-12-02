<template>
  <div>Search View</div>
</template>

<script>
export default {
  name: "SearchView",
  components: {},
  created() {
    this.$store.dispatch("setup", {
      csrf_token: this.$cookies.get("csrf_token"),
    });
  },
};
</script>
