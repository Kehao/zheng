class RegistrationsController < Devise::RegistrationsController
  http_basic_authenticate_with :name => "matz", :password => "password", :only => [:new]
end
