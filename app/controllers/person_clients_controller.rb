class PersonClientsController < ApplicationController
  def index
    @person_clients = current_user.person_clients.includes(:person).limit(5)
  end

  def show
    @company_client = current_user.person_cliemts.includes(:person).find(params[:id])
  end

  def create
    @person = Person.find(params[:person_id])
    current_user.people.push(@person) unless current_user.people.exists?(@person)

    respond_to do |f|
      f.html
      f.js
      f.json { head :created }
    end
  end
end
