class AddProcessBarToImporter < ActiveRecord::Migration
  def change
    add_column :importers, :process_bar, :string
  end
end
