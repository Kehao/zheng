class CreateAlarmConfigs < ActiveRecord::Migration
  def change
    create_table :alarm_configs do |t|
      t.belongs_to :user
      t.boolean :court

      t.timestamps
    end
  end
end
