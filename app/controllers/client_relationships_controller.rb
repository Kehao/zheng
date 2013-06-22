#encoding: utf-8
# Super class that provide a class method to auto define actions for sub classs
class ClientRelationshipsController < ApplicationController
  before_filter :find_client

  def create
    if params[:client_company_relationship]
      create_client_company_relationship
    else
      create_client_person_relationship
    end

    respond_to do |f|
      if @relationship.persisted?
        f.json { 
          render json: {
            result: "success", 
            html: render_to_string(partial: "relationship.html.haml", locals: {client: @client, relationship: @relationship}) 
          }
        }
      else
        f.json { render json: {result: "failed", error: @relationship.errors.full_messages} }
      end
    end
  end

  #{"relationship"=>{"expiration_date"=>"2013-04-06"}
  #{"relationship"=>{"hold_percent"=>"0.52"}
  #{"relationship"=>{"relate_type"=>"sub_company"}
  def update
    relationship = 
    if params[:target_type] == "company"
     @client.company_relationships.find(params[:id])
    else
     @client.person_relationships.find(params[:id])
    end
    respond_to do |format|
      if relationship.update_attributes(params[:relationship])
        #format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content } # 204 No Content
      else
        #format.html { render action: "edit" }
        format.json { render text: relationship.errors.full_messages.join(","), status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if params[:target_type] == "company"
      @client.company_relationships.find(params[:id]).destroy
    else
      @client.person_relationships.find(params[:id]).destroy
    end

    respond_to do |f|
      f.js { head :no_content }
    end
  end

  private
  def find_client
    @client = current_user.company_clients.find(params[:company_client_id])
  end

  def create_client_person_relationship
    @relationship = @client.person_relationships.create(params[:client_person_relationship])
  end

  def create_client_company_relationship
    company_params = params[:client_company_relationship].delete(:company)
    @company = Company.where(name: company_params[:name]).first_or_create(company_params)

    if @company.persisted?
      @relationship = @client.company_relationships.create(params[:client_company_relationship].merge(:company => @company))
    else
      # 即使公司保存不成功，也新建一个relationship对象，后面统一处理
      @relationship = @client.company_relationships.build(params[:client_company_relationship].merge(:company => @company))
      @relationship.valid?
    end
  end
end
