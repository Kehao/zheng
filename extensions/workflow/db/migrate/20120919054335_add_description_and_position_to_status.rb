class AddDescriptionAndPositionToStatus < ActiveRecord::Migration
  def change
    add_column :workflow_statuses, :description, :string
    add_column :workflow_statuses, :position, :integer
  end
end
