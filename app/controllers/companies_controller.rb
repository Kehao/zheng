class CompaniesController < ApplicationController
  respond_to :json, :html
  #load_and_authorize_resource

  def show
    @company = Company.find(params[:id])
    respond_to do |f|
      f.html 
      f.json { render json: @company}
    end
  end

  def update
    @company = Company.find(params[:id])
    @company_client = CompanyClient.find(params[:client_id])
    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html{ redirect_to @company_client}
      else
        @credit = @company.credit || @company.credit.new
        (4 - @credit.operators.count).times{ @credit.operators.build }
        (5 - @credit.equips.count).times{ @credit.equips.build }
        (5 - @credit.loans.count).times{ @credit.loans.build }
        (5 - @credit.morts.count).times{ @credit.morts.build }
        (3 - @credit.holder_changes.count).times{ @credit.holder_changes.build }
        (3 - @credit.mass_changes.count).times{ @credit.mass_changes.build }
        format.html{ render "credits/edit" }
      end
    end
  end

  def update_company
    company = current_user.companies.find(params[:id])
    respond_to do |format|
      if company.update_attributes(params[:company])
        #format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content } # 204 No Content
      else
        #format.html { render action: "edit" }
        format.json { render text: company.errors.full_messages.join(","), status: :unprocessable_entity }
      end
    end
  end

  def update_business
    company = current_user.companies.find(params[:id])
    business = company.business

    updated = 
    unless company.business
      business = company.build_business(params[:business])
      business.save
    else
      business.update_attributes(params[:business])
    end

    business.recount

    respond_to do |format|
      if updated 
        #format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content } # 204 No Content
      else
        #format.html { render action: "edit" }
        format.json { render text: company.business.errors.full_messages.join(","), status: :unprocessable_entity }
      end
    end

  end

  def create
    @company = current_user.add_company(params[:company])
    respond_to do |f|
      f.html { redirect_to company_clients_path }
      f.json { render json: @company }
    end
  end

  def search
    @companies = Company.seek(company_name: params[:key])
    respond_with(@companies)
  end

  def destroy
    @company_client = current_user.company_clients.find_by_company_id(params[:id])
    @company = @company_client.company
    current_user.company_clients.delete @company_client
  end
end

