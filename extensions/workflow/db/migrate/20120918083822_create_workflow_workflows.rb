class CreateWorkflowWorkflows < ActiveRecord::Migration
  def change
    create_table :workflow_workflows do |t|
      t.integer :tracker_id,   :default => 0, :null => false
      t.integer :old_status_id,:default => 0, :null => false
      t.integer :new_status_id,:default => 0, :null => false
      t.integer :role_id,      :default => 0, :null => false
      t.timestamps
    end
  end
end
