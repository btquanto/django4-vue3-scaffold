<template>
  <div class="$flex $flex-col">
    <table class="$border-separate">
      <colgroup>
        <col class="$w-10" />
        <col class="$w-64" />
        <col class="" />
        <col class="$w-40" />
        <col class="$w-40" />
      </colgroup>
      <thead class="$text-grey-700 $bg-gray-100 $uppercase">
        <tr>
          <th scope="col" class="$border $px-6 $py-3"></th>
          <th scope="col" class="$border $px-6 $py-3">{{ tt("Task Name") }}</th>
          <th scope="col" class="$border $px-6 $py-3">{{ tt("Description") }}</th>
          <th scope="col" class="$border $px-6 $py-3">{{ tt("Priority") }}</th>
          <th scope="col" class="$border $px-6 $py-3">{{ tt("Status") }}</th>
          <th scope="col" class="$border $px-6 $py-3">{{ tt("Action") }}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(item, index) in todoItems" :key="item.__uuid__" class="odd:$bg-white even:$bg-gray-50 $border-b">
          <td class="$border $px-6 $py-3 $text-center">{{ index + 1 }}</td>
          <td class="$border $px-6 $py-3 $text-left">{{ item.name }}</td>
          <td class="$border $px-6 $py-3 $text-left">{{ item.description }}</td>
          <td class="$border $px-6 $py-3 $text-center">{{ PriorityText(item.priority) }}</td>
          <td class="$border $px-6 $py-3 $text-center">{{ StatusText(item.status) }}</td>
          <td class="$border $px-6 $py-3 $text-center">
            <button :title="tt('Edit')" @click="$router.push(`/edit/${item.id}`)"><PencilAltIcon class="$h-6 $w-6 $mr-4" /></button>
            <button :title="tt('Delete')" @click="deleteTodoItem(item)"><TrashIcon class="$h-6 $w-6" /></button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="$mt-4 $w-full $flex $flex-row $justify-end">
    <button class="$flex $flex-row $items-center $px-3 $py-1 $bg-cyan-600 hover:$bg-cyan-700 $rounded-full $text-white $w-max" @click="$router.push('/add')">
      <PlusIcon class="$h-4 $w-4" /> <span class="$ml-1">{{ tt("Add") }}</span>
    </button>
  </div>
</template>
<script setup>
import "@/assets/css/tailwind.css";
import { mapGetters } from "vuex";
import { TrashIcon, PlusIcon, PencilAltIcon } from "@heroicons/vue/solid";
import { PriorityText, StatusText } from "./models/refs";
</script>
<script>
export default {
  name: "TodoList",
  computed: {
    ...mapGetters(["todoItems"]),
  },
  created() {
    this.$store.dispatch("fetchTodoItems", {
      csrf_token: this.$global.csrf_token,
    });
  },
  methods: {
    deleteTodoItem(item) {
      this.$store.dispatch("deleteTodoItem", {
        csrf_token: this.$global.csrf_token,
        item,
      });
    },
  },
};
</script>

<style scoped></style>
