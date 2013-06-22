require "skyeye_apollo/engine"

module SkyeyeApollo
  mattr_accessor :user_class_name
  mattr_accessor :company_class_name

  def self.user_class
    user_class_name.constantize
  end

  def self.company_class
    company_class_name.constantize 
  end

  def self.root
    @root ||= Pathname.new(File.expand_path("../../", __FILE__))
  end
end
