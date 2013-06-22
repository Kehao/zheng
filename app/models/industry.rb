class Industry < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: true
  
  has_many :companies
end
