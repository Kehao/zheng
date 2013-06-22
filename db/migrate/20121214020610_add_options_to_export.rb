class AddOptionsToExport < ActiveRecord::Migration
  def change
    add_column :exports, :options, :text
  end
end
