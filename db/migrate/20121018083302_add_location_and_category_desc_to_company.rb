class AddLocationAndCategoryDescToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :region_code,   :string, limit: 8
    add_column :companies, :category_desc, :string
  end
end
