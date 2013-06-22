class CreateClientPersonRelationships < ActiveRecord::Migration
  def change
    create_table :client_person_relationships do |t|
      t.references :client, polymorphic: true
      t.references :person
      t.string     :person_name
      t.string     :person_number
      t.text       :desc

      t.timestamps
    end
  end
end
