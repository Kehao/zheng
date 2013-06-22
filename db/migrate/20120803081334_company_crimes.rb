class CompanyCrimes < ActiveRecord::Migration
  def change
    create_table :company_crimes do |t|
      t.references :company
      t.references :crime
    end
  end
end
