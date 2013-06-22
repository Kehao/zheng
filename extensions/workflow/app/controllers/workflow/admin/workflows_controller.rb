module Workflow
  class Admin::WorkflowsController < ApplicationController
    layout "application"
    expose(:roles){Role.all}
    expose(:trackers){Tracker.all}

    def edit
      @role = ::Workflow.role_class.find_by_id(params[:role_id])
      @tracker = Tracker.find_by_id(params[:tracker_id])

      if request.post?
        Workflow.destroy_all( ["role_id=? and tracker_id=?", @role.id, @tracker.id])
        (params[:workflow_status] || []).each { |status_id, transitions|
          transitions.each { |new_status_id, options|
            author = options.is_a?(Array) && options.include?('author') && !options.include?('always')
            assignee = options.is_a?(Array) && options.include?('assignee') && !options.include?('always')
            @role.workflows.build(:tracker_id => @tracker.id, :old_status_id => status_id, :new_status_id => new_status_id, :author => author, :assignee => assignee)
          }
        }
        if @role.save
          redirect_to :action => 'edit', :role_id => @role, :tracker_id => @tracker
          return
        end
      end
      if @tracker  
        @statuses = @tracker.statuses
      end

      if @tracker && @role && @statuses && @statuses.any?
        workflows = Workflow.all(:conditions => {:role_id => @role.id, :tracker_id => @tracker.id})
        @workflows = {}
        @workflows['always'] = workflows.select {|w| !w.author && !w.assignee}
        @workflows['author'] = workflows.select {|w| w.author}
        @workflows['assignee'] = workflows.select {|w| w.assignee}
      end
    end

  end
end
