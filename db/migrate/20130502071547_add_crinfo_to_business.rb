class AddCrinfoToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :scale,  :integer
    add_column :businesses, :sales,  :integer
    add_column :businesses, :profit, :integer
    add_column :businesses, :credit, :integer
  end
end
