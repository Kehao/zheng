class CreateUserClients < ActiveRecord::Migration
  def change
    create_table :user_clients do |t|
      t.references :user
      t.references :client, polymorphic: true
      
      t.timestamps
    end
  end
end
