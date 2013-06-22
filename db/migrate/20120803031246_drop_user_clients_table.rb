class DropUserClientsTable < ActiveRecord::Migration
  def up
    drop_table :user_clients 
  end

  def down
    create_table :user_clients do |t|
      t.references :user
      t.references :client, polymorphic: true
      
      t.timestamps
    end
  end
end
