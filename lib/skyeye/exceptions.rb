module Skyeye
  #  class MissingSettings < StandardError; end
  #  class ObsoleteSettings < StandardError; end
  class NoKeyProvided < Exception; end
end
#
#class ActionController::Base
#  rescue_from Skyeye::MissingSettings,  :with => :render_fat_free_crm_exception
#  rescue_from Skyeye::ObsoleteSettings, :with => :render_fat_free_crm_exception
#
#  private
#
#  def render_fat_free_crm_exception(exception)
#    logger.error exception.inspect
#    render :layout => false, :template => "/layouts/500.html.haml", :status => 500, :locals => { :exception => exception.to_s.html_safe }
#  end
#end
#
