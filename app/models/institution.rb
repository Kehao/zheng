class Institution < ActiveRecord::Base
  attr_accessible :logo, :name, :short_name
  has_many  :employees, class_name: "User", dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
end
