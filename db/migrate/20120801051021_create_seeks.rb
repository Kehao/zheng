class CreateSeeks < ActiveRecord::Migration
  def change
    create_table :seeks do |t|
      t.string  :company_name
      t.string  :company_number
      t.string  :person_name
      t.string  :person_number

      t.boolean :crawled,  :default => false

      t.timestamps
    end
  end
end
