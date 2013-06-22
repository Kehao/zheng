require 'rubygems'
require 'active_support/core_ext'
require 'rspec'
require 'rspec/autorun'
require 'factory_girl_rails'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'snapshot'


Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RAILS_ROOT= File.expand_path('../../../../../', __FILE__)

RSpec.configure do |config|
  config.after do
    FactoryGirl.reload
  end
end

