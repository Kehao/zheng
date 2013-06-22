class PersonCrimes < ActiveRecord::Migration
  def change
    create_table :person_crimes do |t|
      t.references :person
      t.references :crime
    end
  end
end
