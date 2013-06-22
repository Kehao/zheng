class CreateUserSeeks < ActiveRecord::Migration
  def change
    create_table :user_seeks do |t|
      t.references :user
      t.references :seek

      t.timestamps
    end
  end
end
