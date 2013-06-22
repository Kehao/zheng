class AddWaterNumberAndElecNumberToSkyeyePowerCompanyAccount < ActiveRecord::Migration
  def change
    add_column :skyeye_power_company_accounts, :water_number, :string
    add_column :skyeye_power_company_accounts, :elec_number, :string
  end
end
