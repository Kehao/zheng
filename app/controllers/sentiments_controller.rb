class SentimentsController < ApplicationController
  def demo
    @company = Company.find(params[:company_id])
  end
end
