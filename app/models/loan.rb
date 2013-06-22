class Loan < ActiveRecord::Base
  attr_accessible *self.attribute_names
  belongs_to :credit
end
