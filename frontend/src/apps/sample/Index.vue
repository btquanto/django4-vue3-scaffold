<template>
  <img alt="Vue logo" src="@/assets/logo.png" />
  <HelloWorld :msg="message" />
</template>

<script>
import { mapGetters } from "vuex";
import HelloWorld from "@/components/HelloWorld.vue";

export default {
  name: "App",
  components: {
    HelloWorld,
  },
  computed: {
    ...mapGetters(["message"]),
  },
  created() {
    this.$store.commit("updateMessage", this.$context.message);
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
