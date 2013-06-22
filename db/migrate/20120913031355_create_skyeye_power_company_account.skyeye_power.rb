# This migration comes from skyeye_power (originally 20120913030743)
class CreateSkyeyePowerCompanyAccount < ActiveRecord::Migration
  def change
    create_table :skyeye_power_company_accounts do |t|
      t.references :company
      t.string  :type
      t.string  :description
      t.timestamps
    end
  end
end
