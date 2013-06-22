class AddApolloFlagsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :apollo_order_status, :integer
    add_column :companies, :apollo_black,        :boolean, :default => false
  end
end
