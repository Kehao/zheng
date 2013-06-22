class AlarmsController < ApplicationController

  def index
    @alarms = current_user.alarms.page

    respond_to do |format|
      format.html 
      format.json { render json: @alarms }
    end
  end

  def show
    @alarm = Alarm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alarm }
    end
  end

  def new
    @alarm = Alarm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alarm }
    end
  end

  def edit
    @alarm = Alarm.find(params[:id])
  end

  def create
    @alarm = Alarm.new(params[:alarm])

    respond_to do |format|
      if @alarm.save
        format.html { redirect_to @alarm, notice: 'Alarm was successfully created.' }
        format.json { render json: @alarm, status: :created, location: @alarm }
      else
        format.html { render action: "new" }
        format.json { render json: @alarm.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @alarm = Alarm.find(params[:id])

    respond_to do |format|
      if @alarm.update_attributes(params[:alarm])
        format.html { redirect_to @alarm, notice: 'Alarm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alarm.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @alarm = Alarm.find(params[:id])
    @alarm.destroy

    respond_to do |format|
      format.html { redirect_to alarms_url }
      format.json { head :no_content }
    end
  end
end
