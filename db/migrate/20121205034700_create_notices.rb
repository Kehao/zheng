class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :subject_id
      t.string :subject_type
      t.text   :carriage
      t.string :type, :null => false

      t.timestamps
    end

    add_index :notices, [:subject_id, :subject_type]
  end
end
