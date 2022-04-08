<template>
  <div class="$flex $flex-col $items-center">
    <h1 class="$font-extrabold">{{ tt("Add Todo Item") }}</h1>
    <div class="$w-96 $mt-6">
      <div class="$relative $z-0 $mb-6 $w-full $group">
        <input
          v-model="form.name"
          type="text"
          name="name"
          class="$block $py-2.5 $px-0 $w-full $text-sm $text-gray-900 $bg-transparent $border-0 $border-b-2 $border-gray-300 $appearance-none focus:$outline-none focus:$ring-0 focus:$border-cyan-600 $peer"
          placeholder=" "
          required />
        <label
          for="name"
          class="$absolute $text-sm $text-gray-500 $duration-300 $transform $-translate-y-6 $scale-75 $top-3 $-z-10 $origin-[0] peer-focus:$left-0 peer-focus:$text-cyan-600 peer-placeholder-shown:$scale-100 peer-placeholder-shown:$translate-y-0 peer-focus:$scale-75 peer-focus:$-translate-y-6"
          >{{ tt("Task Name") }}</label
        >
      </div>
      <div class="$relative $z-0 $mb-6 $w-full $group">
        <select
          v-model="form.priority"
          name="priority"
          class="$block $py-2.5 $px-0 $w-full $text-sm $text-gray-900 $bg-transparent $border-0 $border-b-2 $border-gray-300 $appearance-none focus:$outline-none focus:$ring-0 focus:$border-cyan-600 $peer"
          placeholder=" "
          required>
          <option v-for="(value, key) in TodoItemPriorities" :key="key" :value="value" class="$p-4">{{ PriorityText(value) }}</option>
        </select>
        <label
          for="priority"
          class="$absolute $text-sm $text-gray-500 $duration-300 $transform $-translate-y-6 $scale-75 $top-3 $-z-10 $origin-[0] peer-focus:$left-0 peer-focus:$text-cyan-600 peer-placeholder-shown:$scale-100 peer-placeholder-shown:$translate-y-0 peer-focus:$scale-75 peer-focus:$-translate-y-6"
          >{{ tt("Task Priority") }}</label
        >
      </div>
      <div class="$relative $z-0 $mb-6 $w-full $group">
        <select
          v-model="form.status"
          name="status"
          class="$block $py-2.5 $px-0 $w-full $text-sm $text-gray-900 $bg-transparent $border-0 $border-b-2 $border-gray-300 $appearance-none focus:$outline-none focus:$ring-0 focus:$border-cyan-600 $peer"
          placeholder=" "
          required>
          <option v-for="(value, key) in TodoItemStatuses" :key="key" :value="value" class="$p-4">{{ StatusText(value) }}</option>
        </select>
        <label
          for="status"
          class="$absolute $text-sm $text-gray-500 $duration-300 $transform $-translate-y-6 $scale-75 $top-3 $-z-10 $origin-[0] peer-focus:$left-0 peer-focus:$text-cyan-600 peer-placeholder-shown:$scale-100 peer-placeholder-shown:$translate-y-0 peer-focus:$scale-75 peer-focus:$-translate-y-6"
          >{{ tt("Task Priority") }}</label
        >
      </div>
      <div class="$relative $z-0 $mb-6 $w-full $group">
        <textarea
          v-model="form.description"
          name="name"
          class="$block $py-2.5 $px-0 $w-full $text-sm $text-gray-900 $bg-transparent $border-0 $border-b-2 $border-gray-300 $appearance-none focus:$outline-none focus:$ring-0 focus:$border-cyan-600 $peer"
          placeholder=" "
          required></textarea>
        <label
          for="name"
          class="$absolute $text-sm $text-gray-500 $duration-300 $transform $-translate-y-6 $scale-75 $top-3 $-z-10 $origin-[0] peer-focus:$left-0 peer-focus:$text-cyan-600 peer-placeholder-shown:$scale-100 peer-placeholder-shown:$translate-y-0 peer-focus:$scale-75 peer-focus:$-translate-y-6"
          >{{ tt("Description") }}</label
        >
      </div>
      <div class="$flex $flex-row $justify-around">
        <button
          class="$text-cyan $bg-gray-100 hover:$bg-gray-200 focus:$ring-4 focus:$outline-none focus:$ring-cyan-300 $font-medium $rounded-lg $text-sm $w-full sm:$w-auto $px-5 $py-2.5 $text-center"
          @click="$router.go(-1)">
          {{ tt("Cancel") }}
        </button>
        <button
          class="$text-white $bg-cyan-600 hover:$bg-cyan-700 focus:$ring-4 focus:$outline-none focus:$ring-cyan-300 $font-medium $rounded-lg $text-sm $w-full sm:$w-auto $px-5 $py-2.5 $text-center"
          @click="updateTodoItem">
          {{ tt("Submit") }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import "@/assets/css/tailwind.css";
import { assign } from "@/utils/Objects";
import { mapGetters } from "vuex";
import { TodoItemPriorities, PriorityText, TodoItemStatuses, StatusText } from "./models/refs";
</script>
<script>
class TodoItemForm {
  constructor(data) {
    this.name = "";
    this.description = "";
    this.priority = 1;
    this.status = 1;
    assign(this, data);
  }

  formData() {
    const form = new FormData();
    form.append("name", this.name);
    form.append("description", this.description);
    form.append("priority", this.priority);
    form.append("status", this.status);
    return form;
  }
}

export default {
  name: "EditTodoItem",
  data() {
    return {
      form: null,
      item: null,
    };
  },
  computed: {
    ...mapGetters(["todoItems"]),
  },
  created() {
    this.form = new TodoItemForm();
  },
  mounted() {
    const index = this.todoItems.findIndex((item) => item.id == this.$route.params.id);
    if (index >= 0) {
      this.item = this.todoItems[index];
      this.form = new TodoItemForm(this.item);
    } else {
      this.$router.replace({ path: "/" });
    }
  },
  methods: {
    updateTodoItem() {
      this.$store
        .dispatch("updateTodoItem", {
          csrf_token: this.$global.csrf_token,
          item: this.item,
          formData: this.form.formData(),
        })
        .then(([res, _]) => {
          if (res.success) {
            this.form = new TodoItemForm();
            this.$router.go(-1);
          }
        });
    },
  },
};
</script>

<style scoped></style>
