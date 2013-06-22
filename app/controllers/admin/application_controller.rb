# coding: utf-8  
class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :require_admin
  
  def require_admin
    unless current_user.admin? 
      flash[:error] = "你没有权限进入管理后台"
      redirect_to root_path
    end
  end
end

