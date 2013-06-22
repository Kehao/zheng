class AddImporterSecureTokenToBill < ActiveRecord::Migration
  def change
    add_column :skyeye_power_bills, :importer_secure_token, :string
  end
end
