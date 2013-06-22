class SeeksController < ApplicationController
  load_and_authorize_resource
  respond_to :json, :html, :xml
  expose(:seeks) { current_user.seeks.order("user_seeks.created_at DESC").limit(10) }
  
  def index
    @seek = Seek.new
  end

  def show
    @seek = Seek.find(params[:id])
    @companies = Company.seek(@seek).page(params[:page])
    respond_with([@seek, @companies]) do |format|
      format.html { render :index }
    end
  end

  def create
    @companies = Company.seek(seek_params).page(params[:page])
    if @companies.first.present? && @companies.first.cert.present?
      crawled = true if seek_params[:company_number] == @companies.first.number  # 精确匹配 
      crawled = true if seek_params[:company_name]   == @companies.first.name    # 精确匹配 
    end
    @seek = current_user.add_seek(seek_params.merge(crawled: crawled))

    respond_with([@seek, @companies]) do |format|
      format.html { render :index }
    end
  end

  def destroy
    @seek = Seek.find(params[:id])
    current_user.seeks.delete @seek
    respond_to do |format|
      format.js
    end
  end

  def delete_all
    current_user.seeks.clear
    respond_to do |format|
      format.js
    end
  end

  private
  def seek_params
    return @seek_params if @seek_params
    category  = params[:seek_content][:category].to_i
    content   = params[:seek_content][:content].strip
    is_number = content.scan(/\d/).count >= 7

    @seek_params =
      if category == 0
        if is_number
          {company_number: content}
        else
          {company_name: content}
        end
      else
        if is_number
          {person_number: content}
        else
          {person_name: content}
        end
      end
  end

end
