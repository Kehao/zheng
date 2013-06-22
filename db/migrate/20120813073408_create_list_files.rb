class CreateListFiles < ActiveRecord::Migration
  def change
    create_table :list_files do |t|
      t.references :user
      t.string :clients_list
      t.string :name
      t.timestamps
    end
  end
end
