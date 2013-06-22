# This migration comes from skyeye_power (originally 20121203070545)
class AddImporterSecureTokenToBill < ActiveRecord::Migration
  def change
    add_column :skyeye_power_bills, :importer_secure_token, :string
  end
end
