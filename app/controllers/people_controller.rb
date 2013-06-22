class PeopleController < ApplicationController
  def show
    @person = Person.find(prams[:id])
  end

  def create
    @person = current_user.add_person(params[:person])
    respond_to do |f|
      f.html { redirect_to clients_path }
      f.json { render json: @person}
    end
  end
end
