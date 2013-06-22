#encoding: utf-8
class Role < ActiveRecord::Base
  attr_accessible :name, :description,:capability,:title

  validates :name, presence: true
  has_one   :capability,:dependent => :destroy

  delegate :can,:to => :capability

  def cando
    can
  end

  def capability=(attrs)
    attrs=Capability.new(attrs.deep_symbolize_keys) if attrs.is_a? Hash
    super(attrs)
  end

  def permissions
    self.class.permissions
  end
  alias_method :setable_permissions, :permissions
  
  def has_ability?(source_name,action)
    ability = can.public_send(source_name)
    return ability.public_send(action) if ability 
    ability
  end

  def has_ability_item?(source_name,action)
    ability = can[source_name]
    if ability
      if ability[action]
        return true
      end
    end
    false
  end

  def self.role_hash
    Skyeye::AccessControl.permissions.to_hash
  end

  class << self
    def permissions
      Skyeye::AccessControl.permissions
    end
    alias_method :default_permissions, :permissions

    def default_permissions_access
      permissions_access[:default]
    end

    def permissions_access
      return @permissions_access if @permissions_access
      @permissions_access = {
        default: {
          cert:         {view: true},
          crime:        {view: true},
          relationship: {view: true, create: true, destroy: true},
          seek:         {view: true, create: true}
        }
      }

      Skyeye.plugins.each do |plugin|
        @permissions_access[:default].merge!(plugin.permissions_access[:default])
      end

      @permissions_access
    end
  end
end
