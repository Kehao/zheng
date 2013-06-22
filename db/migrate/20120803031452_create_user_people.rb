class CreateUserPeople < ActiveRecord::Migration
  def change
    create_table :user_people do |t|
      t.references :user
      t.references :person

      t.timestamps
    end
  end
end
