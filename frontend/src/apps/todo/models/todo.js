import moment from "moment";
import { uuid, assign } from "@/utils/Objects";
import { gettext } from "@/utils/i18n";

function StatusTextMap() {
  if (StatusTextMap._cache) return StatusTextMap._cache;
  const map = {};
  map[TodoItemStatus.InProgress] = gettext("In Progress");
  map[TodoItemStatus.Done] = gettext("Done");
  StatusTextMap._cache = map;
  return map;
}

function PriorityTextMap() {
  if (PriorityTextMap._cache) return PriorityTextMap._cache;
  const map = {};
  map[TodoItemPriority.Urgent] = gettext("Urgent");
  map[TodoItemPriority.High] = gettext("High");
  map[TodoItemPriority.Medium] = gettext("Medium");
  map[TodoItemPriority.Low] = gettext("Low");
  PriorityTextMap._cache = map;
  return map;
}

export class TodoItemStatus {
  static InProgress = "in_progress";
  static Done = "done";

  static getText(value) {
    return StatusTextMap()[value] || "N/A";
  }
}

export class TodoItemPriority {
  static Urgent = 4;
  static High = 3;
  static Medium = 2;
  static Low = 1;

  static getText(value) {
    return PriorityTextMap()[value] || "N/A";
  }
}

export class TodoItem {
  constructor(data) {
    this.__uuid__ = uuid();
    this.id = null;
    this.name = "";
    this.description = "";
    this.priority = TodoItemPriority.Low;
    this.status = TodoItemStatus.InProgress;
    this.created_at = moment();
    this.updated_at = moment();
    this.assign(data);
  }

  assign(data) {
    const __uuid__ = this.__uuid__;
    assign(this, data, { __uuid__ });
    typeof this.created_at === "string" && (this.created_at = moment(this.created_at));
    typeof this.updated_at === "string" && (this.updated_at = moment(this.updated_at));
  }

  priorityText() {}
}
