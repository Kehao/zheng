class MessagesController < ApplicationController
  def read
    @messages = current_user.read_messages.page(params[:page]).order("id desc")
  end

  def unread
    @messages = current_user.unread_messages.page(params[:page]).order("id desc")
    @current_unread_msg_count = current_user.unread_messages_count
  end

  def reading
    @message = current_user.unread_messages.find(params[:id])
    @message.reading
    respond_to do |f|
      f.js { head :no_content }
    end
  end

  def reading_some
    @messages = current_user.unread_messages.where(:id => params[:ids])
    @messages.each(&:reading)
    respond_to do |f|
      f.js { head :no_content }
    end
  end

  def reading_all
    @messages = current_user.unread_messages
    @messages.each(&:reading)
    respond_to do |f|
      f.js { head :no_content }
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy
    respond_to do |f|
      f.js { head :no_content }
    end
  end

  def destroy_some
    @messages = current_user.messages.where(:id => params[:ids])
    @messages.each(&:destroy)
    respond_to do |f|
      f.js { head :no_content }
    end
  end
end
