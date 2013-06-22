class AddCompanyAccountIdToBill < ActiveRecord::Migration
  def change
    add_column :skyeye_power_bills, :company_account_id, :integer
  end
end
