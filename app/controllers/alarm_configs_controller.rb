# encoding: utf-8
class AlarmConfigsController < ApplicationController

  def edit
    unless current_user.alarm_config
      @alarm_config = current_user.create_alarm_config
    end
    @alarm_config = current_user.alarm_config
  end

  def update
    @alarm_config = current_user.alarm_config

    respond_to do |format|
      if @alarm_config.update_attributes(params[:alarm_config])
        format.html { redirect_to @alarm_config, notice: '告警设置已更新.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alarm_config.errors, status: :unprocessable_entity }
      end
    end
  end

end
