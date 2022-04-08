<template>
  <div class="$flex $flex-col $items-center">
    <h1 class="$font-extrabold">{{ tt("Add Todo Item") }}</h1>
    <div class="$w-96 $mt-6">
      <text-field v-model="form.name" :label="tt('Task Name')" name="name" class="$w-full $mb-6" />
      <select-field v-model="form.priority" :label="tt('Task Priority')" name="priority" class="$w-full $mb-6" :options="TodoItemPriorities" :get-label="PriorityText" />
      <select-field
        v-if="mode == 'update'"
        v-model="form.status"
        :label="tt('Task Status')"
        name="priority"
        class="$w-full $mb-6"
        :options="TodoItemStatuses"
        :get-label="StatusText" />
      <text-area-field v-model="form.description" :label="tt('Task Description')" name="description" class="$w-full $mb-6" />
      <div class="$flex $flex-row $justify-around">
        <form-button type="cancel" :label="tt('Cancel')" @click="$router.go(-1)" />
        <form-button type="confirm" :label="tt('Submit')" @click="submit" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { assign } from "@/utils/Objects";
import { mapGetters } from "vuex";
import { TodoItemPriority, TodoItemStatus } from "./models/todo";
import { TodoItemPriorities, PriorityText, TodoItemStatuses, StatusText } from "./models/refs";

import TextField from "@/components/forms/TextField";
import SelectField from "@/components/forms/SelectField";
import TextAreaField from "@/components/forms/TextAreaField";
import FormButton from "@/components/forms/FormButton";
</script>
<script>
class TodoItemForm {
  constructor(data) {
    this.name = "";
    this.description = "";
    this.priority = TodoItemPriority.Medium;
    this.status = TodoItemStatus.InProgress;
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
      mode: "insert",
    };
  },
  computed: {
    ...mapGetters(["todoItems"]),
  },
  created() {
    this.form = new TodoItemForm();
  },
  mounted() {
    this.mode = this.$route.path == "/add" ? "insert" : "update";
    if (this.mode == "update") {
      const index = this.todoItems.findIndex((item) => item.id == this.$route.params.id);
      if (index >= 0) {
        this.item = this.todoItems[index];
        this.form = new TodoItemForm(this.item);
      } else {
        this.$router.replace({ path: "/" });
      }
    }
  },
  methods: {
    submit() {
      const action = this.mode == "insert" ? "addTodoItem" : "updateTodoItem";
      const payload = {
        csrf_token: this.$global.csrf_token,
        item: this.item,
        formData: this.form.formData(),
      };
      this.$store.dispatch(action, payload).then(([res, _]) => {
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
