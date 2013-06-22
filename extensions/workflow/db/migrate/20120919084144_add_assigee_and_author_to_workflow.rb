class AddAssigeeAndAuthorToWorkflow < ActiveRecord::Migration
  def self.up
    add_column :workflow_workflows, :assignee, :boolean, :null => false, :default => false
    add_column :workflow_workflows, :author, :boolean, :null => false, :default => false
    #::Workflow::Workflow.update_all("assignee = #{Workflow::Workflow.connection.quoted_false}")
    #::Workflow::Workflow.update_all("author = #{Workflow::Workflow.connection.quoted_false}")
  end

  def self.down
    remove_column :workflow_workflows, :assignee
    remove_column :workflow_workflows, :author
  end
end
