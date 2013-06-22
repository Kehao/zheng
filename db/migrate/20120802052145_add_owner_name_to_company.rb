class AddOwnerNameToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :owner_name, :string
  end
end
