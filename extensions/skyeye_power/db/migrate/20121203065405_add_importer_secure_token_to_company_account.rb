class AddImporterSecureTokenToCompanyAccount < ActiveRecord::Migration
  def change
    add_column :skyeye_power_company_accounts, :importer_secure_token, :string
  end
end
