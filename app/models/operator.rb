class Operator < ActiveRecord::Base
  attr_accessible *self.attribute_names
  belongs_to :credit

  include Enumerize
  enumerize :category, in: [:owner, :ceo, :cto, :cfo]
  enumerize :sex,      in: [:m, :f]

end
