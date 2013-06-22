require "skyeye_power/engine"

module SkyeyePower
  mattr_accessor :user_class_name
  mattr_accessor :company_class_name

  class << self
    def user_class
      self.user_class_name.constantize
    end

    def company_class
      self.company_class_name.constantize 
    end
  end
end
