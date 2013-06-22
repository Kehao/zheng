class AddImportedByToUserCompanies < ActiveRecord::Migration
  def change
    add_column :company_clients, :list_file_id, :integer
  end
end
