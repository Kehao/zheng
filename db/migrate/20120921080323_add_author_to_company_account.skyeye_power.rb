# This migration comes from skyeye_power (originally 20120921080220)
class AddAuthorToCompanyAccount < ActiveRecord::Migration
  def change
    add_column :skyeye_power_company_accounts, :author_id, :integer
  end
end
