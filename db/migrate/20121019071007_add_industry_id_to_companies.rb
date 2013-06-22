class AddIndustryIdToCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :category_desc 
    add_column    :companies, :industry_id, :integer

    add_index     :companies, :industry_id
  end

  def down
    add_column    :companies, :category_desc, :string
    remove_column :companies, :industry_id
  end
end
