class CreateWorkflowTraces < ActiveRecord::Migration
  def change
    create_table :workflow_traces do |t|
      t.references :trackable, :polymorphic => true
      t.references :tracker
      t.references :status
      t.integer :assigned_to_id
      t.timestamps
    end
  end
end
