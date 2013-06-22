#encoding: utf-8
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #include PublicActivity::Model
  #include Statistic::Client::RegionCompanyCourt 
  include Statistic::User

  #activist

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :role_id, :institution_id

  has_many :company_clients, dependent: :destroy
  has_many :companies, through: :company_clients 
  has_many :company_owners, through: :companies, source: :owner

  has_many :person_clients, dependent: :destroy
  has_many :people, through: :person_clients

  has_many :user_seeks
  has_many :seeks, through: :user_seeks

  has_many :importers, dependent: :destroy

  has_many :alarms 

  belongs_to  :role
  belongs_to  :institution

  has_many :exporters, :dependent => :destroy
  has_one  :statistic, :class_name => "Statistic::Client"
  has_many :plugins, :class_name => "UserPlugin"

  has_one  :alarm_config

  has_many :messages,        :foreign_key => "recipient_id", :dependent => :destroy
  has_many :read_messages,   :class_name => "Message", :foreign_key => "recipient_id", :conditions => {:read => true},  :dependent => :destroy
  has_many :unread_messages, :class_name => "Message", :foreign_key => "recipient_id", :conditions => {:read => false}, :dependent => :destroy

  unrepeat_add :seeks,     uniq_keys: [:company_name, :company_number, :person_name, :person_number]
  unrepeat_add :companies, uniq_keys: [:person_name]
  unrepeat_add :people,    uniq_keys: [:number]

  before_create :check_role

  # 导出更新的公司信息(法院信息)
  #
  # === Options
  # [:except_closed]
  #    是否排除已结的案件, true/false, default false
  def export_problem_company_clients_updated_after(time, path = nil, options = {})
    options = options.reverse_merge(:except_closed => false)
    now = Time.now.strftime("%Y-%m-%d")
    path = File.join(Rails.root, "public/system/#{self.name}_updated_problem_companies_#{now}.xls")

    old_problem_company_clients = company_clients.court_problem.add_before(time)
    new_problem_company_clients = company_clients.court_problem.add_after(time)

    companies_crimes = []

    # process old problem company clients crimes
    old_problem_company_clients.each do |company_client|
      crimes = []
      company_client.crimes_after(time).each do |crime|
        next if options[:except_closed] && crime.closed?
        crimes << crime
      end
      companies_crimes << [company_client, crimes] if crimes.present?
    end

    # process new problem company clients crimes
    new_problem_company_clients.each do |company_client|
      crimes = []
      company_client.all_crimes.each do |crime|
        next if options[:except_closed] && crime.closed?
        crimes << crime
      end
      companies_crimes << [company_client, crimes] if crimes.present?
    end

    Exporter::Excel.export_companies_crimes(companies_crimes, path)

    path
  end

  # =========================================
  # =>暂无法人
  # validates_associated :company
  # =========================================
  def create_company_client_with_company_and_company_owner(company_client_attrs)
    company_client_attrs ||= {}
    company_attrs = company_client_attrs.delete(:company)
    company= Importer.search_company(company_attrs)
    if company
      company_client = self.company_clients.where(:company_id=>company.id).first
      unless company_client 
        company_client = self.company_clients.new(company_client_attrs)
        company_client.company = company
      end
    else
      company =  Company.create(company_attrs)
      company_client = self.company_clients.new(company_client_attrs)
      company_client.company = company
    end

    if company_client.new_record?
      company_client.save
    end

    company_client
  end

  # =========================================
  # Get User's role and his ability
  # =========================================
  #
  def cando
    role.try(:capability).try(:can)
  end
  
  def check_role
    self.role_id = 100001 unless self.role_id
  end

  def admin?
    role.name == 'admin'
  end

  def guest?
    new_record?
  end

  def member?
    !guest?
  end

  # === Example
  #   role?(:admin)
  #   role?(:guest)
  #   role?(:member)
  def role?(name)
    case name
    when :guest
      guest?
    when :member
      member?
    else
      role.try(:name) == name.to_s
    end
  end

  # =======================================================================
  # load current_user's companies all region list into a well known filter.
  # =======================================================================
  #
  # 把当前用户的所有地区可选项挑选出来
  def load_region 
    return @region_h if defined? @region_h

    @region_h = {
      "000000" => {code: "000000", name: "全部", sub: {}}
    }
    all_region_code = self.companies.select(:region_code).uniq.map(&:region_code).compact

    all_region_code.each do |code|
      region_all = @region_h["000000"]

      province_code   = code[0..1].ljust(6, "0")
      province_region = AreaCN.get(province_code)
      next if !province_region.present? || !province_region.province?
      region_all[:sub][province_code] = {code: province_code, name: province_region.try(:name), sub:{}} unless region_all[:sub][province_code]
      region_province = region_all[:sub][province_code]
      
      city_code       = code[0..3].ljust(6, "0")
      city_region     = AreaCN.get(city_code)
      next if !city_region.present? || !city_region.city?
      region_province[:sub][city_code] = {code: city_code, name: city_region.try(:name), sub:{}} unless region_province[:sub][city_code]
      region_city = region_province[:sub][city_code]

      district_code   = code
      district_region = AreaCN.get(district_code)
      next if !district_region.present? || !district_region.district?
      region_city[:sub][district_code] = {code: district_code, name: district_region.try(:name)} unless region_city[:sub][district_code]
    end

    @region_h
  end

  def company_clients_regions_in(code = '000000')
    code = AreaCN::Code.new(code)

    sub_codes = if code.prefix == nil
                  self.load_region['000000'][:sub].keys
                elsif code.prefix.length == 2
                  self.load_region['000000'][:sub][code][:sub].keys
                elsif code.prefix.length == 4
                  self.load_region['000000'][:sub][code.parent][:sub][code][:sub].keys
                else
                  []
                end

    sub_codes.map { |code| AreaCN.get(code) }.compact
  end

end
