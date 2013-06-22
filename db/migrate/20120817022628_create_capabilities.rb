class CreateCapabilities < ActiveRecord::Migration
  def change
    create_table :capabilities do |t|
      t.text :can,:null => false
      t.belongs_to :user,:default=>nil
      t.belongs_to :role,:default=>nil

      t.timestamps
    end
    add_index :capabilities,:user_id
    add_index :capabilities,:role_id
  end
end
