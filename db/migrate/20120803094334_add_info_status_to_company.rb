class AddInfoStatusToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :idinfo_status, :string
    add_column :companies, :court_status,  :string
    add_column :companies, :water_status,  :string
    add_column :companies, :power_status,  :string
    add_column :companies, :sentiment_status, :string
  end
end
