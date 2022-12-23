import Material from "./material";

export default class Company {
  constructor({
    edinet_code = "",
    security_code = "",
    company_name = "",
    company_address = "",
    industry = "",
    balance_sheet_url = "",
    consolidated_balance_sheet_url = "",
    profit_loss_url = "",
    consolidated_profit_loss_url = "",
    meeting_explanatory_materials_url = "",
    growth_potential_materials_url = "",
    materials = [],
  } = {}) {
    this.edinet_code = edinet_code;
    this.security_code = security_code;
    this.company_name = company_name;
    this.company_address = company_address;
    this.industry = industry;
    this.balance_sheet_url = balance_sheet_url;
    this.consolidated_balance_sheet_url = consolidated_balance_sheet_url;
    this.profit_loss_url = profit_loss_url;
    this.consolidated_profit_loss_url = consolidated_profit_loss_url;
    this.meeting_explanatory_materials_url = meeting_explanatory_materials_url;
    this.growth_potential_materials_url = growth_potential_materials_url;
    this.materials = materials.map((item) => new Material(item));
  }
}
