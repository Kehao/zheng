class AddDescriptionToTracker < ActiveRecord::Migration
  def change
    add_column :workflow_trackers, :description, :string
  end
end
