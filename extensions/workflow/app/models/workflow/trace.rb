module Workflow
  class Trace < ActiveRecord::Base
      attr_accessible :tracker_id, :status_id, :assigned_to_id
      belongs_to :trackable, :polymorphic => true
      belongs_to :tracker
      belongs_to :status
      belongs_to :assignee,:class_name => ::Workflow.user_class_name, :foreign_key => "assigned_to_id"

      validates :tracker,:status,:presence => true
  end
end
