class AddAuthorToCompanyAccount < ActiveRecord::Migration
  def change
    add_column :skyeye_power_company_accounts, :author_id, :integer
  end
end
