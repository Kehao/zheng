class UserSeek < ActiveRecord::Base
  belongs_to :user
  belongs_to :seek

  validates_uniqueness_of :seek_id, :scope => :user_id
end
