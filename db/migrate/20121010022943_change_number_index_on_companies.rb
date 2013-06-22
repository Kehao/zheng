class ChangeNumberIndexOnCompanies < ActiveRecord::Migration
  def up
    remove_index :companies, :number
    add_index    :companies, :number
  end

  def down
  end
end
