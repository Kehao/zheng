class AddCountToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :count, :integer
  end
end
