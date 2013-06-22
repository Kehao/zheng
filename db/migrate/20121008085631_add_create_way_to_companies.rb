class AddCreateWayToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :create_way, :integer, default: Company::CREATE_WAY[:manual]
  end
end
