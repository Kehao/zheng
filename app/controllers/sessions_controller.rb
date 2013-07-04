class SessionsController < Devise::SessionsController
  http_basic_authenticate_with :name => "matz", :password => "password", 
    :only => [:new]
end
