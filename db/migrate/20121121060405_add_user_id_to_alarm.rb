class AddUserIdToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :user_id, :integer
  end
end
