<template>
  <sidebar
    class="$bg-cyan-600 $text-cyan-100 $w-64 $py-4 $absolute $inset-y-0 $left-0 $transform $-translate-x-full $transition $duration-200 $ease-in-out"
    :class="{
      '$relative $-translate-x-0': showSidebar,
    }">
    <a href="#" class="$flex $items-center $px-2">
      <AcademicCapIcon class="$h-8 $w-8" />
      <span class="$ml-1 $text-2xl $font-extrabold">Sample App</span>
    </a>
    <nav>
      <template v-for="link in navLinks" :key="link.name">
        <a :href="link.href" class="$flex $items-center $px-3 $py-4 $group hover:$bg-cyan-700 $transition $duration-200">
          <component :is="link.icon" class="$h-6 $w-6" /> <span class="$ml-1 $text-white group-hover:$text-cyan-300">{{ link.name }}</span>
        </a>
      </template>
    </nav>
  </sidebar>
</template>

<script setup>
import { ref } from "vue";
import { mapGetters } from "vuex";
import { gettext } from "@/utils/i18n";

import { AcademicCapIcon, HomeIcon, UserGroupIcon, FolderIcon, CalendarIcon, DocumentDuplicateIcon, DocumentReportIcon } from "@heroicons/vue/solid";

const navLinks = ref([
  { icon: HomeIcon, href: "#", name: gettext("Dashboard") },
  { icon: UserGroupIcon, href: "#", name: gettext("Team") },
  { icon: FolderIcon, href: "#", name: gettext("Projects") },
  { icon: CalendarIcon, href: "#", name: gettext("Calendar") },
  { icon: DocumentDuplicateIcon, href: "#", name: gettext("Documents") },
  { icon: DocumentReportIcon, href: "#", name: gettext("Reports") },
]);
</script>

<script>
export default {
  name: "SideBar",
  computed: {
    ...mapGetters(["showSidebar"]),
  },
};
</script>

<style scoped></style>
