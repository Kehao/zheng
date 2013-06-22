#class ActivitiesController < ApplicationController
#  respond_to :json,:html,:xml
#  include PublicActivity::StoreController
#  expose(:owner) do
#    if params[:owner_id] && params[:owner_type]
#      Kernel.const_get(params[:owner_type]).find(params[:owner_id])
#    end
#  end
#
#  expose(:activities){owner.activities.order("created_at desc").page}
#
#  def index
#  end
#end
