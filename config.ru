# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# FAYE => for reloading page when some thing completed.
# require 'faye'
# use Faye::RackAdapter, :mount => '/faye', :timeout => 10

run Skyeye::Application
