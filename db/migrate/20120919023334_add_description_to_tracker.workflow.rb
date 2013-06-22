# This migration comes from workflow (originally 20120919023157)
class AddDescriptionToTracker < ActiveRecord::Migration
  def change
    add_column :workflow_trackers, :description, :string
  end
end
