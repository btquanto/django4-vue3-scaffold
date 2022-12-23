<template>
  <div class="$flex $flex-col">Search View</div>
</template>
<script setup>
import { mapGetters, mapActions } from "vuex";
</script>
<script>
export default {
  name: "SearchView",
  computed: {
    ...mapGetters([]),
  },
  created() {
    this.$store.dispatch();
  },
  methods: {
    ...mapActions([]),
  },
};
</script>

<style scoped></style>
