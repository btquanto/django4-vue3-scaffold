import moment from "moment";
import { uuid, assign } from "@/utils/Objects";

export class TodoItemStatus {
  static InProgress = "in_progress";
  static Done = "done";
}

export class TodoItem {
  constructor(data) {
    this.__uuid__ = uuid();
    this.name = "";
    this.description = "";
    this.priority = 5;
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
}
