#encoding: utf-8
module Workflow
  class Admin::TrackersController < ApplicationController
    layout "application"
    expose(:trackers){Tracker.all}

    def index
    end

    def create
      @tracker = Tracker.new(params[:tracker])
      if @tracker.save
        redirect_to [:admin,:trackers],notice: '跟踪标签新建成功'
      else
        render :index
      end
    end

    def update
      tracker = Tracker.find(params[:id])
      if tracker.update_attributes(params[:tracker])
        redirect_to [:admin,:trackers],notice: '跟踪标签修改成功'
      else
        redirect_to [:admin,:trackers],alert:"修改失败:#{tracker.errors.full_messages.join(',')}"
      end
    end

    def destroy
      tracker = Tracker.find(params[:id])
      tracker.destroy
      redirect_to [:admin,:trackers]
    end

  end
end
