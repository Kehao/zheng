class HomeController < ApplicationController
  def index
    attrs = %w{companies.id crimes.updated_at name reg_date case_state apply_money party_number court_name case_id apply_money}
    @crimes = current_user.companies.joins(:crimes).select(attrs).order("crimes.updated_at ASC").limit(11)

    @risk_companies   = current_user.company_clients.joins(:company).where("companies.court_status != 'ok'").limit(5)
    @recent_companies = current_user.company_clients.order("created_at ASC").limit(5)
    @companies_cont = Company.all.count

    @company_client = current_user.company_clients.new
    @company_client.company = Company.new
    @companies_credit = current_user.stats_basic_companies_credit
  end
end
