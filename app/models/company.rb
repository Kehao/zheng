# encoding: utf-8
class Company < ActiveRecord::Base
  include ActiveModel::Observing
  include Crimeable
  
  validates :name, presence: true, uniqueness: true
  
  INFO_STATUS = [:null, :info, :success, :warning, :important] # 状态
  enumerize :idinfo_status, in: INFO_STATUS, default: :null

  # how the company been loaded into system.
  # apollo: 2
  CREATE_WAY = {
    manual:  0,
    crawled: 1,
    import:  3
  }

  attr_accessible :name,           #姓名
                  :number,         #工商注册号
                  :owner_name,     #法人姓名
                  :code,           #组织机构号
                  :region_code,    #所在地编码
                  :create_way,
                  :industry_id,
                  :idinfo_crawled, :court_crawled, 
                  :idinfo_status,  :court_status, 
                  :water_company_accounts_count, 
                  :elec_company_accounts_count,
                  :business_attributes,
                  :cert_attributes,
                  :credit_attributes


  has_one :spider, as: :sponsor, dependent: :destroy

  belongs_to :owner,  class_name: 'Person'
  belongs_to :holder, class_name: 'Person', foreign_key: "owner_id" # dup for ransack search

  belongs_to :industry
  delegate   :name, to: :industry, prefix: true, allow_nil: true

  has_many   :company_clients, dependent: :destroy
  has_many   :users, through: :company_clients
  
  has_many   :court_alarms, as: :subject

  has_one  :cert, dependent: :destroy
  has_one  :business, dependent: :destroy
  has_one  :credit, dependent: :destroy

  accepts_nested_attributes_for :cert,allow_destroy: true
  accepts_nested_attributes_for :credit, allow_destroy: true
  accepts_nested_attributes_for :business, allow_destroy: true



  delegate :address, 
           :regist_capital, 
           :paid_in_capital, 
           :company_type, 
           :found_date, :business_scope, 
           :business_start_date, :business_end_date, :business_period, 
           :regist_org,
           :approved_date, :check_years,
           to: :cert, allow_nil: true
  delegate :credit_avg_txt,
           to: :business, allow_nil: true
  
  # Don't call persistent methods like save/update_attributes in after_commit callbacks,
  # it will cause deep callstack exception.
  after_commit :generate_spider, on: :create

  class << self
    def seek(seek_params = {})
      # 通过号码找出法人名称
      # if seek_params[:person_name].blank? && seek_params[:person_number].present?
      #   person = Person.where(number: seek_params[:person_number]).first
      #   seek_params[:person_name] = person && person.name || seek_params[:person_number]
      # end
      companies = includes(:owner).search(
        name_eq:                        seek_params[:company_name],
        number_eq:                      seek_params[:company_number],
        owner_name_or_holder_name_eq:   seek_params[:person_name],
        owner_number_eq:                seek_params[:person_number]
      ).result

      companies = includes(:owner).search(
        name_cont:                      seek_params[:company_name],
        owner_name_or_holder_name_cont: seek_params[:person_name]
      ).result if companies.limit(1).blank?

      companies
    end

    def create_with_cert(cert_attrs = {})
      company = where(name: cert_attrs[:name]).first_or_initialize(
        number:     cert_attrs[:regist_id],
        owner_name: cert_attrs[:owner_name],
        create_way: CREATE_WAY[:crawled]
      )

      # cert 抓取过来的信息部分被idinfo省略, 因此用validate false
      if company.save
        company.create_cert(cert_attrs) unless company.cert.present?
      end

      company
    end

    # ===================================
    # Scoped methods
    # ===================================
    #
    def uncrawled
      where('`companies`.`court_crawled` = ? OR `companies`.`idinfo_crawled` = ?', false, false)
    end

    # === Parameters
    # * status
    #   company court status value array like Company.problem_court_status_values
    #
    # === Options
    # [:include_owner]
    #   true/false, default true
    def by_court_status(status, options = {})
      options = options.reverse_merge(:include_owner => true)

      searched = if options[:include_owner]
        search(:court_status_or_owner_court_status_in => status)
      else
        search(:court_status_in => status)
      end

      searched.result
    end

    # Those have problem court status are problem companies(有法院信息的企业, 即为问题企业)
    def court_problem(options = {})
      by_court_status(Company.problem_court_status_values, options)
    end

    alias_method :problem, :court_problem
  end

  def trigger_notify_observers(*args)
    notify_observers(*args)
  end

  ## ======================================= 
  ## functions of valify cert status from its cert
  ## and sync some attributes from cert.
  ## =======================================
  def valify_cert_status
    return self unless idinfo_crawled # if the idinfo -cert was not crawld
    if cert
      blank_size = cert.attributes.keys.inject(0) do |sum, item|
        cert[item].present? ? sum : (sum + 1)
      end
      company_crawled_status = blank_size >= 3 ? :warning : :success #found some good or bad cert info
    else
      company_crawled_status = :important # can not found any cert
    end
    update_blank_attributes_from_cert
    update_attributes({idinfo_status: company_crawled_status})
  end

  def update_blank_attributes_from_cert
    return self if cert.blank?
    
    if read_attribute(:owner_name).blank? && cert.owner_name.present?
      update_attributes(owner_name: cert.owner_name) 
    end

    if number.blank? && cert.try(:regist_id) =~ /^(\d{6})/
      update_attributes(number: cert.regist_id) 
    end

    self
  end

  ## ======================================= 
  ## functions of crimes relevant
  ## fetch crimes status and crimes list.
  ## =======================================
  # === Options
  # [:include_owner]
  #   true/false, default true
  def has_problem?(options = {})
    options = options.reverse_merge(:include_owner => true)

    problem = self.class.problem_court_status.include?(court_status)

    if options[:include_owner]
      problem || owner.try(has_problem?)
    else
      problem
    end
  end
  alias_method :problem?, :has_problem?
  
  def all_crimes
    @all_crimes ||= if owner_id.present?
      Crime.where("(`party_id` = ? AND `party_type` = 'Company') OR (`party_id` = ? AND `party_type` = 'Person')", id, owner_id)
    else
      crimes
    end
  end

  def crimes_after(time)
    all_crimes.select { |crime| crime.updated_at > time }
  end

  ## ======================================= 
  ## functions of snapshot relevant
  ## get snapshot of crimes and idinfos
  ## =======================================
  def get_crimes_snapshot
    all_crimes.each do |crime|
      crime.get_snapshot
    end
  end

  def get_idinfo_snapshot
    cert.get_snapshot
  end

  def get_snapshots
    get_idinfo_snapshot
    get_crimes_snapshot
  end

  ## ======================================= 
  ## functions of attributes
  ## area and number 
  ## =======================================
  def owner_name
    read_attribute(:owner_name).presence || owner.try(:name) || cert.try(:owner_name)
  end

  def area
    region_code ? AreaCN.get(region_code) : nil
  end

  def area_desc
    if area
      area.province? ? area.name : area.parent.name + " - " + area.name
    else
      "未知"
    end
  end

  # override number= to assign region_code from number
  def number=(value)
    super
    if region_code.blank? && number =~ /^(\d{6})/
      if code = number[0..5]             and AreaCN.get(code).present?
        self.region_code = code 
      elsif code = number[0..3] + "00"   and AreaCN.get(code).present? 
        self.region_code = code
      elsif code = number[0..1] + "0000" and AreaCN.get(code).present?
        self.region_code = code
      end
    end

    number
  end

  def court_status_with_owner
    if self.owner
      self.class.select_worst_court_status([self.owner.court_status, court_status])
    else
      court_status
    end
  end

  # sync company infos through spider.
  def sync(options = {})
    if spider
      spider.re_schedule_to_run options
    else
      generate_spider
    end

    if owner.present? && owner.spider.present?
      owner.spider.re_schedule_to_run options
    elsif owner.present?
      owner.generate_spider
    end
  end

  # 预警公司(包括法人)新的法院信息
  def alarm_court
    alarmed_crime_ids = self.court_alarms.map(&:crime_ids).flatten.uniq
    # For only processing and other crimes
    new_crime_ids = self.all_crimes.outstanding.pluck(:id) - alarmed_crime_ids
    if new_crime_ids.present?
      self.court_alarms.create(:carriage => {:crime_ids => new_crime_ids})
    end
  end

  # ==============================
  # random a fake business
  # ==============================
  def rand_business
    b = business || build_business
    b.worker_number_of_this_year ||= random_attr(1000)
    b.worker_number_of_last_year ||= random_attr(1000)
    b.worker_number_of_the_year_before_last ||= random_attr(1000)

    b.income_of_this_year ||=  random_attr(1300)
    b.income_of_last_year ||= random_attr(1220) 
    b.income_of_the_year_before_last ||= random_attr(3900) 

    b.assets_of_this_year ||= random_attr(190) 
    b.assets_of_last_year ||= random_attr(200) 
    b.assets_of_the_year_before_last ||= random_attr(250) 

    b.debt_of_this_year ||= random_attr(1300)   
    b.debt_of_last_year ||= random_attr(1200)   
    b.debt_of_the_year_before_last ||= random_attr(1800) 

    b.profit_of_this_year ||= random_attr(1100) 
    b.profit_of_last_year ||= random_attr(1200) 
    b.profit_of_the_year_before_last ||= random_attr(1300)  

    b.order_amount_of_this_year ||= random_attr(1000) 
    b.order_amount_of_last_year ||= random_attr(1200) 
    b.order_amount_of_the_year_before_last ||= random_attr(1400) 

    b.vat_of_this_year ||= random_attr(10)    
    b.vat_of_last_year ||= random_attr(12)    
    b.vat_of_the_year_before_last ||= random_attr(14)  

    b.income_tax_of_this_year ||= random_attr(20) 
    b.income_tax_of_last_year ||= random_attr(30) 
    b.income_tax_of_the_year_before_last ||= random_attr(35)  

    b.elec_charges_monthly_of_this_year ||= random_attr(2000) 
    b.elec_charges_monthly_of_last_year ||= random_attr(2000) 
    b.elec_charges_monthly_of_the_year_before_last ||= random_attr(3000) 

    b.water_charges_monthly_of_this_year ||= random_attr(100) 
    b.water_charges_monthly_of_last_year ||= random_attr(100)  
    b.water_charges_monthly_of_the_year_before_last ||= random_attr(100)  

    b.major_income_of_this_year ||= random_attr(1000) 
    b.major_income_of_last_year ||= random_attr(1000) 
    b.major_income_of_the_year_before_last ||= random_attr(1000)

    if ii = random_attr(20)
      self.industry_id = Industry.find(98 + ii).id 
      save
    end
    b.save
  end
  
  private 
  def random_attr(size, blank_size = 5)
    r = (::Random.rand(size)) + 2
    ::Random.rand(blank_size) == 0 ? nil : r
  end

  def generate_spider
    CompanySpider.create(sponsor: self)
  end
end
