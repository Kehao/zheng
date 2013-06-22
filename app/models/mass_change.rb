class MassChange < ActiveRecord::Base
  attr_accessible *self.attribute_names
  belongs_to :credit
end
