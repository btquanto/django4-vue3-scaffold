import Company from "./company";

export class Material {
  constructor({ type = "", file_name = "", url = "", content = "", company = null } = {}) {
    this.type = type;
    this.file_name = file_name;
    this.url = url;
    this.content = content;
    if (company) {
      this.company = new Company(company);
    }
  }
}
