require "workflow/engine"


module Workflow
  mattr_accessor :user_class_name
  mattr_accessor :company_account_class_name
  mattr_accessor :role_class_name

  def self.user_class
    user_class_name.constantize
  end

  def self.company_account_class
    company_account_class_name.constantize 
  end

  def self.role_class
    role_class_name.constantize
  end

  def self.root
    @root ||= Pathname.new(File.expand_path("../../", __FILE__))
  end
end
