class Alarm < ActiveRecord::Base
  attr_accessible :content, :name,:count
  belongs_to :user
end
