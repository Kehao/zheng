# coding: utf-8  
class Admin::UsersController < Admin::ApplicationController

  def index
    @users = User.order("created_at DESC").page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.email = params[:user][:email]
    @user.name = params[:user][:login]
    
    if @user.update_attributes(params[:user])
      redirect_to(admin_users_path, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(admin_users_url) 
  end
end
