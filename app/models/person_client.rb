class PersonClient < ActiveRecord::Base
  attr_accessible :person_name, :person_number
  belongs_to :user
  belongs_to :person

  has_many :company_relationships, class_name: "ClientCompanyRelationship", as: :client
  has_many :person_relationships,  class_name: "ClientPersonRelationship",  as: :client

  validates_uniqueness_of :user_id, scope: :person_id
end
