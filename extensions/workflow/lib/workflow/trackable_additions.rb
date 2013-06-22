module Workflow
  module TrackableAdditions

    def trace=(attrs)
      attrs=::Workflow::Trace.new(attrs.deep_symbolize_keys) if attrs.is_a? Hash
      super(attrs)
    end

    def new_statuses_allowed_to(user,include_default=false)
      if new_record?
        [Status.default]
      else
        statuses =
          if self.trace && self.trace.status
            initial_status = Status.default
            statuses = self.trace.status.find_new_statuses_allowed_to(
              user.admin? ? ::Workflow.role_class.all : user.role,
              self.trace.tracker,
              author == user,
              self.trace.assigned_to_id_changed? ? self.trace.assigned_to_id_was == user.id : self.trace.assigned_to_id == user.id
            )
          end || []
        statuses << initial_status unless statuses.empty?
        statuses << Status.default if include_default
        statuses.compact.uniq.sort
        #blocked? ? statuses.reject {|s| s.is_closed?} : statuses
      end
    end

  end
end
