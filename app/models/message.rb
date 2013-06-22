class Message < ActiveRecord::Base
  attr_accessible :recipient, :event

  belongs_to :recipient, :class_name => "User", :foreign_key => :recipient_id
  belongs_to :event,     :polymorphic => true

  validates  :recipient, :event, :presence => true

  after_create  :increment_recipient_unread_messages_count
  before_update :decrement_recipient_unread_messages_count

  def reading
    self.read = true
    self.save
  end

  private
  # Do not user increment! and decrment!, it not correct in concurrency circumstance
  def increment_recipient_unread_messages_count
    unless self.read
      User.increment_counter(:unread_messages_count, self.recipient_id)
    end
  end

  def decrement_recipient_unread_messages_count
    if self.read_changed? && self.read == true
      User.decrement_counter(:unread_messages_count, self.recipient_id)
    end
  end
end
