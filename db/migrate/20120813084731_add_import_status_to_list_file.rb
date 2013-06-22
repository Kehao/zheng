class AddImportStatusToListFile < ActiveRecord::Migration
  def change
    add_column :list_files, :import_status, :integer, default: 0 # waiting/importing/complete
  end
end
