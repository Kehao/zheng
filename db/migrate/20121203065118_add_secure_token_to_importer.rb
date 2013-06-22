class AddSecureTokenToImporter < ActiveRecord::Migration
  def change
    add_column :importers, :secure_token, :string
  end
end
