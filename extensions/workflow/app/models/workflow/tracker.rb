module Workflow
  class Tracker < ActiveRecord::Base
    attr_accessible :is_in_chlog, :name,:description
    has_many :workflows, :dependent => :destroy
    has_many :statuses, :dependent => :destroy

    validates :name, :presence => true,   :length => { :maximum => 30 }
  end
end
