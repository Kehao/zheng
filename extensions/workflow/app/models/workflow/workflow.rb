module Workflow
  class Workflow < ActiveRecord::Base
    attr_accessible :tracker_id, :old_status_id, :new_status_id, :author, :assignee
    belongs_to :role,:class_name => ::Workflow.role_class_name
    belongs_to :old_status, :class_name => 'Status', :foreign_key => 'old_status_id'
    belongs_to :new_status, :class_name => 'Status', :foreign_key => 'new_status_id'
  end
end
