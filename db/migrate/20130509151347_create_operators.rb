class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.references :credit

      t.string :category
      t.string :name
      t.string :sex
      t.date   :birthday
      t.string :number
      t.string :education
      t.string :position
      t.string :address
      t.string :zip
      t.text   :cv
      t.string :negative
      t.timestamps
    end
  end
end