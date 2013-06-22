#encoding: utf-8
class Notice < ActiveRecord::Base
  attr_accessible :subject, :carriage, :type

  serialize  :carriage, Hash

  belongs_to :subject,  :polymorphic => true
  has_many   :messages, :as => :event

  def self.notify_all
    self.find_each(&:notify)
  end
end
