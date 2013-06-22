#encoding: utf-8
class Credit < ActiveRecord::Base
  attr_accessible *(self.attribute_names + [:operators_attributes, :equips_attributes, :loans_attributes, :morts_attributes, :mass_changes_attributes, :holder_changes_attributes])
  belongs_to :company

  has_many :operators, dependent: :destroy
  accepts_nested_attributes_for :operators, allow_destroy: true, :reject_if => proc { |attributes| attributes['name'].blank? }
  
  has_many :equips,    dependent: :destroy
  accepts_nested_attributes_for :equips,    allow_destroy: true, :reject_if => proc { |attributes| attributes['name'].blank? }

  has_many :loans,     dependent: :destroy
  accepts_nested_attributes_for :loans,     allow_destroy: true, :reject_if => proc { |attributes| attributes['name'].blank? }

  has_many :morts,     dependent: :destroy
  accepts_nested_attributes_for :morts,     allow_destroy: true, :reject_if => proc { |attributes| attributes['name'].blank? }

  has_many :mass_changes,     dependent: :destroy
  accepts_nested_attributes_for :mass_changes, allow_destroy: true, :reject_if => proc { |attributes| attributes['event'].blank? }

  has_many :holder_changes,     dependent: :destroy
  accepts_nested_attributes_for :holder_changes, allow_destroy: true, :reject_if => proc { |attributes| attributes['name'].blank? }
end
