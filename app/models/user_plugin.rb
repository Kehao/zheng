class UserPlugin < ActiveRecord::Base
  attr_accessible :plugin_name

  belongs_to :user

  validates :plugin_name, :presence => true
  validates_uniqueness_of :plugin_name, :scope => :user_id

  def name
    plugin_name
  end

  def plugin
    @plugin ||= Skyeye.plugins.find_by_name(plugin_name)
  end

  def method_missing(method, *args, &block)
    if plugin.respond_to?(method)
      plugin.send(method)
    else
      super
    end
  end
end
