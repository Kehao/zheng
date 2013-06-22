# This migration comes from skyeye_power (originally 20121203065405)
class AddImporterSecureTokenToCompanyAccount < ActiveRecord::Migration
  def change
    add_column :skyeye_power_company_accounts, :importer_secure_token, :string
  end
end
