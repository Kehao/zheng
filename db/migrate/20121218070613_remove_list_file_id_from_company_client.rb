class RemoveListFileIdFromCompanyClient < ActiveRecord::Migration
  def up
    remove_column :company_clients, :list_file_id
    add_column :company_clients, :importer_secure_token, :string,default: nil
  end

  def down
    add_column :company_clients, :list_file_id, :integer
    remove_column :company_clients, :importer_secure_token
  end
end
