# This migration comes from skyeye_apollo (originally 20121225070649)
class AddCustinfoidToApolloBusiness < ActiveRecord::Migration
  def change
    add_column :skyeye_apollo_apollo_businesses, :custinfoid, :integer
    add_index  :skyeye_apollo_apollo_businesses, :custinfoid
  end
end
