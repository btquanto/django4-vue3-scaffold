<template>
  <div>
    <table class="$border-separate $w-full">
      <thead class="$text-grey-700 $bg-gray-100 $uppercase">
        <tr>
          <th scope="col" class="$border $px-6 $py-3">No</th>
          <th scope="col" class="$border $px-6 $py-3">Task Name</th>
          <th scope="col" class="$border $px-6 $py-3">Description</th>
          <th scope="col" class="$border $px-6 $py-3">Status</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(item, index) in todoItems" :key="item.__uuid__" class="odd:$bg-white even:$bg-gray-50 $border-b">
          <td class="$border $px-6 $py-3 $text-center">{{ index + 1 }}</td>
          <td class="$border $px-6 $py-3 $text-left">{{ item.name }}</td>
          <td class="$border $px-6 $py-3 $text-left">{{ item.description }}</td>
          <td class="$border $px-6 $py-3 $text-center">{{ item.status }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script setup>
import "@/assets/css/tailwind.css";
import { mapGetters } from "vuex";
</script>
<script>
export default {
  name: "TodoList",
  computed: {
    ...mapGetters(["todoItems"]),
  },
};
</script>

<style scoped></style>
