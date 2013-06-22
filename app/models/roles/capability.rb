#encoding: utf-8
class Capability < ActiveRecord::Base
  attr_accessible :can,:role_id
  belongs_to :user
  belongs_to :role
  serialize :can, Can

  validates :can, presence: true

  # Overide to instantiate a Can instance
  def can=(abilities)
    can = abilities.is_a?(Can) ? abilities : Can.new(abilities)
    super(can)
  end

end
