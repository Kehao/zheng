#encoding: utf-8
require "helpers"

module API 
  class Companies < Grape::API
    formatter :json, Grape::Formatter::Rabl
    helpers Helpers

    resource :companies do 

      desc '公司搜索'
      params do 
        requires :company_name,:desc=>"公司名",:type=>String
        optional :page,:desc=> "当前页(默认1)",:type=>Integer
        optional :per_page,:desc=> "每页数(默认10)",:type=>Integer 
      end

      get "/search",:rabl => "companies/index" do
        @companies = params[:company_name] && Company.seek(:company_name=>params[:company_name]).page(params[:page]).per(params[:per_page||10]) || []
      end

      # Example
      #   curl http://localhost:3000/api/v1/companies
      desc '公司列表'
      params do 
        optional :page,:desc=> "当前页(默认1)",:type=>Integer
        optional :per_page,:desc=> "每页数(默认10)",:type=>Integer 
      end
      get "/",:rabl => "companies/index" do
        @companies = Company.page(params[:page]).per(params[:per_page] || 10)
      end

      desc '获取公司详细资料' 
      params do 
        requires :id,:desc=>"公司id",:type=>Integer
      end
      get ":id",:rabl => "companies/show" do
        @company = Company.includes(:cert,:business,:credit).find_by_id(params[:id])
      end

      desc "新建一个公司", :notes=> 
      <<-NOTE
 Example
-----------------

   curl -d "company[name]=test1" http://localhost:3000/api/v1/companies

   curl -d "company[name]=test2 & company[business_attributes][sales_area]=test" http://localhost:3000/api/v1/companies

   curl -d "company[name]=test3 & company[business_attributes][sales_area]=test & company[credit_attributes][operators_attributes][][name]=123" http://localhost:3000/api/v1/companies
      NOTE
      params do 
        group :company do
          requires :name,:type=>String,:desc=>"公司名称"
          group :cert_attributes do
            optional :business_scope,:type=>String,:desc=>"同时创建cert信息"
          end
          group :business_attributes do
            optional :sales_area,:type=>String,:desc=>"同时创建business信息"
          end
          group :credit_attributes do
            optional :reg_address,:type=>String,:desc=>"同时创建credit信息"
            #optional :operators_attributes,:type => Array[Hash]
          end
        end
      end

      post "/",:rabl => "companies/show"do
        @company = Company.create(params[:company])
        if @company.new_record? 
          error!({ "error" => "新建公司失败", 
                 "detail" => @company.errors.full_messages.join(",") }, 400)
        end
      end

      desc "修改一个公司", :notes=> 
      <<-NOTE
 Example
-----------------

   curl -X PUT -d "company[name]=test1" http://localhost:3000/api/v1/companies/1

   curl -X PUT -d "company[name]=test2 & company[business_attributes][sales_area]=test" http://localhost:3000/api/v1/companies/1

   curl -X PUT -d "company[name]=test3 & company[business_attributes][sales_area]=test & company[credit_attributes][operators_attributes][][name]=123" http://localhost:3000/api/v1/companies/1
      NOTE
      params do 
        requires :id,:type=>Integer,:desc=>"公司id"
        group :company do
          group :cert_attributes do
            optional :business_scope,:type=>String,:desc=>"同时修改cert信息"
          end
          group :business_attributes do
            optional :sales_area,:type=>String,:desc=>"同时修改business信息"
          end
          group :credit_attributes do
            optional :reg_address,:type=>String,:desc=>"同时修改credit信息"
            #optional :operators_attributes,:type => Array[Hash]
          end
        end
      end

      put ":id",:rabl => "companies/show"do
        @company = search_company_or_error!
        unless @company.update_attributes(params[:company])
          error!({ "error" => "修改公司失败", 
                 "detail" => @company.errors.full_messages.join(",") }, 400)
        end
      end

      # Example
      #   curl -d  business[sales_area]=test http://localhost:3000/api/v1/companies/1/business
      desc "新建[修改]公司的bussiness信息", :notes=> 
      <<-NOTE
        Example
        -----------------

          curl -d "business[sales_area]=test" http://localhost:3000/api/v1/companies/1/business
      NOTE
      params do 
        requires :id,:type=>Integer,:desc=>"公司id"
        group :business do
            optional :sales_area,:type=>String,:desc=>"新建business信息"
        end
      end

      post ":id/business",:rabl => "companies/show" do
        @company = search_company_or_error!
        create_or_update_has_one_assoc_or_error!(@company,:business,params[:business])
      end

      # Example
      #   curl -d cert[name]=test http://localhost:3000/api/v1/companies/1/cert
      desc "新建[修改]公司的cert信息", :notes=> 
      <<-NOTE
        Example
        -----------------

          curl -d "cert[name]=test" http://localhost:3000/api/v1/companies/1/cert
      NOTE
      params do 
        requires :id,:type=>Integer,:desc=>"公司id"
        group :cert do
          optional :business_scope,:type=>String,:desc=>"修改cert信息"
        end
      end

      post ":id/cert",:rabl => "companies/show" do
        @company = search_company_or_error!
        create_or_update_has_one_assoc_or_error!(@company,:cert,params[:cert])
      end

      # Example
      #   curl --form  credit[reg_address]=test http://localhost:3000/api/v1/companies/1/credit
      desc "新建[修改]公司的credit信息", :notes=> 
      <<-NOTE
        Example
        -----------------

          curl -d "credit[reg_address]=test" http://localhost:3000/api/v1/companies/1/credit
      NOTE
      params do 
        requires :id,:type=>Integer,:desc=>"公司id"
        group :credit do
          optional :reg_address,:type=>String,:desc=>"修改credit信息"
        end
      end

      post ":id/credit",:rabl => "companies/show" do
        @company = search_company_or_error!
        create_or_update_has_one_assoc_or_error!(@company,:credit,params[:credit])
      end

    end 
  end
end
#post ":id/business",:rabl => "companies/show" do
#  @company = search_company_or_error!
#  search_has_one_assoc_and_error!(@company,:business)
#  create_has_one_assoc_or_error!(@company,:business,params[:business])
#end

