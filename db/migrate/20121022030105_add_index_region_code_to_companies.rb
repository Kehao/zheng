class AddIndexRegionCodeToCompanies < ActiveRecord::Migration
  def change
    add_index :companies, :region_code
  end
end
