class AddWaterCompanyAccountsCountAndElecCompanyAccountsCountToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :water_company_accounts_count, :integer,default:0
    add_column :companies, :elec_company_accounts_count, :integer,default:0
  end
end
