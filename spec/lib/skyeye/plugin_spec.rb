#encoding: utf-8
require 'spec_helper'

Skyeye::Plugin.register do |plugin|
  plugin.name          = "test"
  plugin.version       = "0.0.1"
  plugin.company_crawl = [:test_resource]

  plugin.access_control do 
    permission :test_resource, [:read, :edit, :destroy]
  end

  plugin.cancan do |user|
    user.cando.test_resource.each do |action, _|
      can action, :test_recource
    end
  end
end

describe Skyeye::Plugin, "天眼插件系统" do
  it "register a plugin should add to skyeye plugins system" do
    Skyeye.plugins.names.should include("test")
  end
  
  it "same resource permission should define once" do
    plugin = Skyeye.plugins.find_by_name("test")
    expect {
      plugin.access_control do
        permission :test_resource, []
      end
    }.to raise_error
  end

  # it "should add correct attributes to register a plugin" do
  #   plugin = Skyeye.plugins.find_by_name("test")
  #   plugin.should be_enable
  #   plugin.company_crawl.should == [:test_resource]
  # end

  it "crawl resources should add to skyeye spider system" do
    CompanySpider.crawl_resources.should include(:test_resource)
  end
end
