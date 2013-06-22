class AddCrimesCountToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :crimes_count, :integer
    add_column :people, :crimes_count, :integer
  end
end
