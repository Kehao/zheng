class AddSecureTokenToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :importer_secure_token, :string
  end
end
