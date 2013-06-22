#encoding: utf-8
class CompanyClientsController < ApplicationController
  respond_to :json, :html, :xml
  load_and_authorize_resource through: :current_user
  skip_load_resource :only => [:index, :court_problem]

  helper_method :selected_region, :params_q

  def index  
    @query = current_user.company_clients.includes(:company,:importer, company: :owner).search(query_params)
    @company_clients = @query.result.order("company_clients.id DESC").page(params[:page])
  end

  def new
    @company_client = current_user.company_clients.new
    @company_client.company = Company.new
  end

  def show
    @company_client = current_user.company_clients.includes(:company, :company_relationships, :person_relationships).find(params[:id])
    @company = @company_client.company
    @company.business.blank? && @company.create_business
    @company.credit.blank? && @company.create_credit
    
    @relationships = @company_client.relationships
    report=CompanyClientReport.new
    report.company_client = @company_client
    respond_to do |f|
      f.html 
      f.json { render json: @company_client}
      f.pdf do 
        send_data report.to_pdf,
          :filename => "(#{Time.now.strftime("%Y%m%d")})#{@company.name}.pdf", 
          :type => "application/pdf" 
      end
    end
  end

  def court_problem
    @q = current_user.companies.problem_companies.includes(:company_clients, :cert, :owner).search(params[:q])
    @companies = @q.result.order("company_clients.created_at DESC").page(params[:page])
    respond_to do |f|
      f.html { 
        @export = current_user.exports.new
        @company_clients = current_user.court_problem_company_clients.includes(:company => [:cert, :owner]).page(params[:page])
        render :index 
      }
      f.xls {
        @export_io_path = current_user.export_problem_company_clients
        send_file @export_io_path
      }
    end
  end

  def create
    # following action response a js page only for adding one client from seek feedback bage.
    @company = Company.find(params[:company_id])
    current_user.companies.push(@company) unless current_user.companies.exists?(@company)
  end

  def create_with_company_and_company_owner
    @company_client = current_user.create_company_client_with_company_and_company_owner(params[:company_client])

    respond_to do |f|
      if @company_client.new_record? 
        f.html { render :new }
      else
        flash[:notice] = "该公司已成功加入您的客户列表!!!"
        f.html { redirect_to new_company_client_path}
      end
    end
  end

  def destroy
    @company_client = current_user.company_clients.find(params[:id])
    current_user.company_clients.delete @company_client
    respond_to do |f|
      f.js { head :no_content }
    end
  end

  def update_snapshot
    crime_id = params[:crime_id]
    if crime_id
      if crime = Crime.find(crime_id)
        crime.update_snapshot
      end
    end
    render :text => "=== crime snapshot update:#{crime.snapshot_at} ==="
  end

  private
  def selected_region
    @selected_region ||= SelectedRegion.new(params_q[:region]) 
  end

  def params_q
    @params_q ||= params[:q] || {}
  end

  def query_params
    return @query_params if defined? @query_params 

    @query_params = params_q.dup

    # process params[:q][:region]
    if query_region = @query_params.delete(:region).presence
      if query_region == SelectedRegion::UNKNOW
        @query_params[:company_region_code_blank] = true
      else
        code = AreaCN::Code.new(query_region)
        @query_params[:company_region_code_start] = code.prefix
      end
    end

    # process params[:q][:court]
    query_court = @query_params.delete(:court)

    if query_court == 'ok'
      groupings = 
        [company_court_status_in: Company.ok_court_status_values] +
        [company_owner_court_status_in: Company.ok_court_status_values, company_owner_id_null: 1, :m => 'or'] 
      @query_params.merge!(:g => groupings)

    elsif query_court.present? && ['warning', 'problem'].include?(query_court)
      @query_params[:company_court_status_or_company_owner_court_status_in] = Company.send("#{query_court}_court_status_values")
    end

    @query_params
  end
end

class SelectedRegion
  UNKNOW = '-1'
  
  attr_reader :code, :name, :region

  def initialize(query_region)
    if query_region.blank?
      @code = nil
      @name = "全部"
    elsif query_region == UNKNOW
      @code = UNKNOW
      @name = "未知"
    else
      @region = AreaCN.get(query_region)
      @code = @region.code
      @name = @region.name
    end
  end
end
