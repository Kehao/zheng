# encoding: utf-8
class StatisticsController < ApplicationController
  layout "demo"
  cattr_accessor :stats do
    {}
  end
  before_filter :set_user
  before_filter :chart_data

  def set_user 
    unless current_user
      sign_in(:user, User.find_by_name("chen")|| User.first)
    end
  end

  class << self
    def cache_result(user_id,type)
      stats[user_id] ||= {} 
      stats[user_id][type] ||= yield 
      stats[user_id][type]
    end
  end
  def cache_result(user_id=current_user.id,type,&block)
    self.class.cache_result(user_id,type,&block)
  end
  include StatisticsHelper
  respond_to :json, :html, :xml

  expose(:tab) do
    params[:tab] || "companies_credit" 
  end

  

  def index
    respond_to do |f|
      f.html  
    end
  end

  private


  def chart_data
    send("chart_#{tab}")
  end

  def chart_report
    [ :companies_court,
      :companies_court_by_area,
      :companies_court_by_industry,
      :companies_court_by_owner,
      :companies_court_by_execute_count,
      :companies_court_by_apply_money,
      :companies_court_by_reg_date
    ].each do |tab|
      send("chart_#{tab}")
    end
  end

  def chart_companies_court_by_reg_date
    @start_month_beginning = 
      if params[:search_crime] 
        convert_date(params[:search_crime],"start_month_beginning").beginning_of_month
      else
        Date.today.prev_year.beginning_of_year
      end
    @end_month_end = 
      if params[:search_crime] 
        convert_date(params[:search_crime],"end_month_end").at_end_of_month
      else
        Date.today.at_end_of_month
      end
    @companies_court_by_reg_date = current_user.stats_companies_court_by_reg_date(@start_month_beginning,@end_month_end)
  end

  def chart_companies_court
    @companies_court    = current_user.stats_companies_court
    @js_companies_court = [
     ["有执行中案件的客户",percentage(@companies_court[:court_percent],2)],
     ["有其它案件的客户",percentage(@companies_court[:closed_or_stoped_or_other_percent],2)],
     ["没有案件的客户",(100 - percentage(@companies_court[:court_percent],2) - percentage(@companies_court[:closed_or_stoped_or_other_percent],2)).round(2)]
   ]
  end


  def chart_companies_court_by_area
    @companies_court_by_area    = current_user.stats_companies_court_by_area

    companies_court_by_area_dup = @companies_court_by_area.dup
    companies_court_by_area_dup.delete("total")
    #:data=>[[stats[:court_count],percentage(stats[:court_percent],2),stats[:court_count]]]}
    @js_companies_court_by_area_categories = companies_court_by_area_dup.values.map { |stats| stats[:name] } 
    @js_companies_court_by_area_data = companies_court_by_area_dup.values.map { |stats| percentage(stats[:court_percent],2) } 
  end

  def chart_companies_court_by_industry
    @companies_court_by_industry = current_user.stats_companies_court_by_industry

    companies_court_by_industry_dup = @companies_court_by_industry.dup
    companies_court_by_industry_dup.delete("合计")
    @js_companies_court_by_industry_categories = companies_court_by_industry_dup.keys 
    @js_companies_court_by_industry_data = companies_court_by_industry_dup.values.map { |stats| percentage(stats[:court_percent],2) } 
  end

  def chart_companies_court_by_owner
    @companies_court_by_owner    = current_user.stats_companies_court_by_owner
    @js_companies_court_by_owner = [
      ["企业主被执行",percentage(@companies_court_by_owner[:owner_percent])], 
      ["企业被执行",percentage(@companies_court_by_owner[:company_percent])], 
      ["企业和企业主都被执行",percentage(@companies_court_by_owner[:double_percent])]
    ]
  end

  def chart_companies_court_by_execute_count
    @companies_court_by_execute_count = current_user.stats_companies_court_by_execute_count[1].sort
  end

  def chart_companies_court_by_apply_money
  end

  
  def chart_companies_credit
    @companies_credit = cache_result(:stats_basic_companies_credit) do
      current_user.stats_basic_companies_credit
    end
  end

  def chart_companies_nature
    @companies_nature = cache_result(:stats_basic_companies_nature)do
      current_user.stats_basic_companies_nature
    end
  end

  def chart_companies_industry
    @companies_industry = cache_result(:stats_basic_companies_industry) do 
      current_user.stats_basic_companies_industry
    end
  end

  def chart_company_clients
    @company_clients = cache_result(:stats_basic_company_clients) do 
      current_user.stats_basic_company_clients
    end
  end

  def chart_companies_regist_capital_by_industry
    @companies_regist_capital_by_industry = cache_result(:stats_basic_companies_regist_capital_by_industry) do 
      current_user.stats_basic_companies_regist_capital_by_industry
    end
  end

  def chart_companies_regist_capital_by_nature
    @companies_regist_capital_by_nature = cache_result(:stats_basic_companies_regist_capital_by_nature) do  
      current_user.stats_basic_companies_regist_capital_by_nature
    end
  end

  def chart_companies_regist_capital_yearly
    @companies_regist_capital_yearly = cache_result(:stats_basic_companies_regist_capital_yearly) do
    current_user.stats_basic_companies_regist_capital_yearly
  end
  end

  def chart_average_companies_worker_number_yearly
    @average_companies_worker_number_yearly = cache_result(:stats_business_average_companies_worker_number_yearly) do 
      current_user.stats_business_average_companies_worker_number_yearly 
    end
  end

  def chart_income
    if params[:subtab].eql?("income_by_nature")
      @average_companies_income_by_nature_yearly = cache_result(:stats_business_average_companies_income_by_nature_yearly) do 
        current_user.stats_business_average_companies_income_by_nature_yearly 
      end
    elsif params[:subtab].eql?("income_by_industry")
      @average_companies_income_by_industry_yearly = cache_result(:stats_business_average_companies_income_by_industry_yearly) do
        current_user.stats_business_average_companies_income_by_industry_yearly 
      end
    else
      @companies_income_total_yearly = cache_result(:stats_business_companies_income_total_yearly) do 
        current_user.stats_business_companies_income_total_yearly 
      end
    end
  end

  def chart_assets
    if params[:subtab].eql?("assets_by_nature")
      @average_companies_assets_by_nature_yearly = cache_result(:stats_business_average_companies_assets_by_nature_yearly) do 
        current_user.stats_business_average_companies_assets_by_nature_yearly 
      end

    elsif params[:subtab].eql?("assets_by_industry")
      @average_companies_assets_by_industry_yearly = cache_result(:stats_business_average_companies_assets_by_industry_yearly) do 
        current_user.stats_business_average_companies_assets_by_industry_yearly 
      end
    else
      @companies_assets_total_yearly = cache_result(:stats_business_companies_assets_total_yearly) do 
        current_user.stats_business_companies_assets_total_yearly 
      end
    end
  end
  
  def chart_profit
    if params[:subtab].eql?("profit_by_nature")
      @average_companies_profit_by_nature_yearly = cache_result(:stats_business_average_companies_profit_by_nature_yearly) do 
        current_user.stats_business_average_companies_profit_by_nature_yearly 
      end
    elsif params[:subtab].eql?("profit_by_industry")
      @average_companies_profit_by_industry_yearly = cache_result(:stats_business_average_companies_profit_by_industry_yearly) do 
        current_user.stats_business_average_companies_profit_by_industry_yearly 
      end
    else
      @companies_profit_total_yearly = cache_result(:stats_business_companies_profit_total_yearly) do 
        current_user.stats_business_companies_profit_total_yearly 
      end
    end
  end



  def convert_date(options,attr_name)
    if options && options["#{attr_name}(1i)"]
      year  = options.delete("#{attr_name}(1i)").to_i
      month = options.delete("#{attr_name}(2i)").to_i
      day   = 1
      options[attr_name.intern] = Date.civil(year, month, day)
      options[attr_name.intern]
    end
  end



end
