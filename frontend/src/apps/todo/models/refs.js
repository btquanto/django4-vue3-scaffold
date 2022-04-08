import { ref } from "vue";
import { TodoItemPriority, TodoItemStatus } from "./todo";

export const TodoItemPriorities = ref(Object.fromEntries(Object.entries(TodoItemPriority)));
export const PriorityText = ref(TodoItemPriority.getText);

export const TodoItemStatuses = ref(Object.fromEntries(Object.entries(TodoItemStatus)));
export const StatusText = ref(TodoItemStatus.getText);
