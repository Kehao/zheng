class CreateWorkflowTrackers < ActiveRecord::Migration
  def change
    create_table :workflow_trackers do |t|
      t.string  :name,:limit => 30, :default => "", :null => false
      t.boolean :is_in_chlog,:default => false, :null => false

      t.timestamps
    end
  end
end
