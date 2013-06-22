class CreateWorkflowStatuses < ActiveRecord::Migration
  def change
    create_table :workflow_statuses do |t|
      t.string  :name,       :limit => 30, :default => "", :null => false
      t.boolean :is_closed,  :default => false, :null => false
      t.boolean :is_default, :default => false, :null => false
      t.string  :html_color, :limit => 6, :default => "FFFFFF", :null => false

      t.timestamps
    end
  end
end
