module Workflow
  class Status < ActiveRecord::Base
    attr_accessible  :name,:description,:is_default,:tracker_id

    has_many :workflows, :foreign_key => "old_status_id",:dependent => :destroy
    belongs_to :tracker

    validates :tracker, :presence => true
    validates :name, :presence => true,   :length => { :maximum => 30 }

    validates_uniqueness_of :is_default, :scope => :tracker_id,:if => :is_default


    def self.default
      find(:first, :conditions =>["is_default=?", true])
    end

    def find_new_statuses_allowed_to(roles, tracker, author=false, assignee=false)
      if roles.present? && tracker
        conditions = "(author = :false AND assignee = :false)"
        conditions << " OR author = :true" if author
        conditions << " OR assignee = :true" if assignee

        workflows.find(:all,
                       :include => :new_status,
                       :conditions => ["role_id IN (:role_ids) AND tracker_id = :tracker_id AND (#{conditions})",
                         {:role_ids => roles.collect(&:id), :tracker_id => tracker.id, :true => true, :false => false}
        ]
                      ).collect{|w| w.new_status}.compact.sort
      else
        []
      end
    end

  end
end
