class Admin::InstitutionsController < Admin::ApplicationController
  respond_to :html, :json, :xml
  expose(:institution)

  def index
    @institutions = Institution.all
    respond_with(@institutions)
  end

  def new
    respond_with(institution)
  end

  def edit
    respond_with(institution)
  end

  def create
    respond_to do |format|
      if institution.save
        format.html { redirect_to [:admin,:institutions], notice: 'Institution was successfully created.' }
        format.json { render json: institution, status: :created, location: institution }
      else
        format.html { render action: "new" }
        format.json { render json: institution.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if institution.update_attributes(params[:institution])
        format.html { redirect_to [:admin,:institutions], notice: 'Institution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: institution.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    institution.destroy 
    respond_to do |f|
      f.js { head :no_content }
    end
  end
end
