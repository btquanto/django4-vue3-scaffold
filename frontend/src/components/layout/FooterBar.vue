<template>
  <footer class="$p-4 $bg-gray-50 $shadow md:$flex md:$items-center md:$justify-between md:$p-6 dark:$bg-gray-800">
    <span class="$text-sm $text-gray-500 sm:$text-center dark:$text-gray-400">© 2022 <a href="#" class="hover:$underline">NLP Search™</a>. All Rights Reserved. </span>
    <ul class="$flex $flex-wrap $items-center $mt-3 $text-sm $text-gray-500 $dark:text-gray-400 sm:$mt-0">
      <li v-for="link in footerLinks" :key="link.name">
        <a :href="link.href" class="$ml-4 hover:$underline md:$ml-6">{{ link.name }}</a>
      </li>
    </ul>
  </footer>
</template>

<script setup>
import { ref } from "vue";
import { $gettext } from "@/utils/i18n";

const footerLinks = ref([
  { href: "#", name: $gettext("About") },
  { href: "#", name: $gettext("Privacy Policy") },
  { href: "#", name: $gettext("Licensing") },
  { href: "#", name: $gettext("Contact") },
]);
</script>
<script>
export default {
  name: "FooterBar",
};
</script>

<style scoped></style>
