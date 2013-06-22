class AddViewStatusToImporter < ActiveRecord::Migration
  def change
    add_column :importers, :view_status, :integer,default:1
  end
end
