#encoding: utf-8
class CompanyClient < ActiveRecord::Base
  attr_accessible :company_id

  belongs_to :user
  belongs_to :company
  
  #保存之前验证 company
  validates_associated :company

  validates :company_id, presence: true

  belongs_to :importer, :primary_key => "secure_token", :foreign_key => "importer_secure_token"

  has_many :company_relationships, class_name: "ClientCompanyRelationship", as: :client, dependent: :destroy
  has_many :person_relationships,  class_name: "ClientPersonRelationship",  as: :client, dependent: :destroy
  has_many :relate_companies, through: :company_relationships, source: :company
  has_many :relate_people,    through: :person_relationships,  source: :person
  
  delegate :name, :number, :code, :owner_name, :all_crimes, :crimes, :crimes_after, :has_problem?, :owner, :sync_update, to: :company
  
  validates_uniqueness_of :user_id, scope: :company_id

  class << self
    # 优先同步更新 成为用户客户 的公司， 更新频率比较高。
    # 如果公司在几百万的情况下，同步所有公司需要消耗大量的资源和时间，所有公司的更新可以一个月更新一次, 甚至更长
    def sync_all(options = {})
      self.uniq.select([:id, :company_id]).find_in_batches do |company_clients|
        Company.where(id: company_clients.map(&:company_id)).each do |c|
          c.sync options
        end
      end
    end

    def sync_only_court_data_of_all_companies
      sync_all(only_crawl: :court)
    end

    # 预警所有的客户公司
    def alarm_court_all
      self.uniq.select([:id, :company_id]).find_in_batches do |company_clients|
        Company.where(id: company_clients.map(&:company_id)).each do |company|
          company.alarm_court
        end
      end
    end

    # ===================================
    # Scoped methods
    # ===================================
    def uncrawled
      includes(:company).where('`companies`.`court_crawled` = ? OR `companies`.`idinfo_crawled` = ?', false, false)
    end

    def add_before(time)
      where("company_clients.created_at <= ?", time)
    end

    def add_after(time)
      where("company_clients.created_at > ?", time)
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
        includes(:company, company: :owner).search(:company_court_status_or_company_owner_court_status_in => status)
      else
        includes(:company).search(:company_court_status_in => status)
      end

      searched.result
    end

    def court_problem(options = {})
      by_court_status(Company.problem_court_status_values, options)
    end
    alias_method :problem, :court_problem
  end

  def relationships
    company_relationships + person_relationships
  end

end
