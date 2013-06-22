require_dependency "skyeye_power/application_controller"

module SkyeyePower
  class HomeController < ApplicationController

    def index
      @company_clients = current_user.company_clients.includes(:company).page(params[:page])
    end
  end
end
