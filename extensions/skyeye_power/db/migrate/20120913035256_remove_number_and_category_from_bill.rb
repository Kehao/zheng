class RemoveNumberAndCategoryFromBill < ActiveRecord::Migration
  def up
    remove_column :skyeye_power_bills, :number
    remove_column :skyeye_power_bills, :category
  end

  def down
    add_column :skyeye_power_bills, :category, :integer
    add_column :skyeye_power_bills, :number, :string
  end
end
