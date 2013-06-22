class ChangeCrimesApplyMoneyColumn < ActiveRecord::Migration
  def up
    change_column :crimes, :apply_money, :float
  end

  def down
    change_column :crimes, :apply_money, :string
  end
end
