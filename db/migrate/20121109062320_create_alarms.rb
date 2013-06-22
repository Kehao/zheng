class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.string :name
      t.string :content
      t.string :type

      t.timestamps
    end
  end
end
