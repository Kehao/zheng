class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error "Access denied on #{exception.action} #{exception.subject.inspect}"
    render file: "public/404.html", status: 404, layout: false
  end
end
