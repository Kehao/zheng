class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :short_name
      t.string :logo

      t.timestamps
    end
  end
end
