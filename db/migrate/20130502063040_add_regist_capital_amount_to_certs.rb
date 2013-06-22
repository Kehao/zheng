class AddRegistCapitalAmountToCerts < ActiveRecord::Migration
  def change
    add_column :certs, :regist_capital_amount, :float
  end
end
