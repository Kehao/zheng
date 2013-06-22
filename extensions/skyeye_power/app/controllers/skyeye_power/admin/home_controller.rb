module SkyeyePower
  module Admin
    class HomeController < ApplicationController
      def index
        @companies = SkyeyePower.company_class.page(params[:page])
      end
    end
  end
end
