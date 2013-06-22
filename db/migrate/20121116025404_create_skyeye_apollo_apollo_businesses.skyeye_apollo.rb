# This migration comes from skyeye_apollo (originally 20121115074729)
class CreateSkyeyeApolloApolloBusinesses < ActiveRecord::Migration
  def up
    create_table :skyeye_apollo_apollo_businesses do |t|
      t.integer :company_id, :null => false
      t.integer :order_status, :default => 0
      t.boolean :black, :default => false

      t.timestamps
    end

    add_index :skyeye_apollo_apollo_businesses, :company_id

    # migrate apollo business attributes from companies
    execute <<-SQL
      INSERT INTO skyeye_apollo_apollo_businesses (SELECT NULL, id, apollo_order_status, apollo_black, created_at, updated_at FROM companies WHERE companies.create_way = 2);
    SQL
  end

  def down
    remove_index :skyeye_apollo_apollo_businesses, :company_id
    drop_table :skyeye_apollo_apollo_businesses
  end
end
