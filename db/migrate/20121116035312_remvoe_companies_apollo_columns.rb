class RemvoeCompaniesApolloColumns < ActiveRecord::Migration
  def up
    remove_column :companies, :apollo_order_status
    remove_column :companies, :apollo_black
  end

  def down
    add_column :companies, :apollo_order_status, :integer
    add_column :companies, :apollo_black, :boolean
  end
end
