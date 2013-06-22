# This migration comes from workflow (originally 20120924030607)
class AddTrackerIdToStatus < ActiveRecord::Migration
  def change
    add_column :workflow_statuses, :tracker_id, :integer
  end
end
