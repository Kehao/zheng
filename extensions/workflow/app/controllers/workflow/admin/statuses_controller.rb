#encoding: utf-8
module Workflow
  class Admin::StatusesController < ApplicationController
    layout "application"
    expose(:statuses){Status.order(:tracker_id)}

    def index
    end
  
    def create
      @status = Status.new(params[:status])
      if @status.save
        redirect_to [:admin,:statuses],notice: '工作状态新建成功'
      else
        render :index

        #redirect_to [:admin,:statuses],alert:"新建失败:#{status.errors.full_messages.join('<br />')}"
      end
    end
  
    def update
      status = Status.find(params[:id])
      if status.update_attributes(params[:status])
        redirect_to [:admin,:statuses],notice: '工作状态更新成功'
      else
        redirect_to [:admin,:statuses],alert:"修改失败:#{status.errors.full_messages.join(',')}"
      end
    end
  
    def destroy
      status = Status.find(params[:id])
      status.destroy
      redirect_to [:admin,:statuses]
    end
  end
end
