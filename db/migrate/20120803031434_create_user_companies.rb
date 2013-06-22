class CreateUserCompanies < ActiveRecord::Migration
  def change
    create_table :user_companies do |t|
      t.references :user
      t.references :company

      t.timestamps
    end
  end
end
