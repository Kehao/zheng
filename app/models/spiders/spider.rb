#encoding: utf-8
class Spider < ActiveRecord::Base
  VALID_CRIME_ATTRIBUTES = [:party_name, :party_number, :case_id, :reg_date, :case_state, :apply_money, :court_name, :orig_url].freeze
  VALID_CERT_ATTRIBUTES  = [
    :regist_id, :name, :address, :owner_name, :regist_capital, :paid_in_capital, :company_type, :found_date,
    :business_scope, :business_start_date, :business_end_date, :regist_org, :approved_date, :check_years, :orig_url
  ].freeze

  attr_accessible :sponsor

  validates_uniqueness_of :sponsor_id, scope: :sponsor_type
  validates               :sponsor_id, :sponsor_type, presence: true

  belongs_to :sponsor, polymorphic: true

  STATUS = {
    waiting:  0,
    running:  1,
    complete: 2
  }

  # Initialize data for new spider, store crawled data into this attribute
  #
  # === Example
  #   spider.data[:idinfo] = [{}, ...]
  #   spider.data[:court]  = [{}, ...]
  serialize :data
  after_initialize do |spider|
    spider.data = {} unless Hash === spider.data
  end

  after_commit :schedule_to_run, on: :create

  class << self
    # 在sidekiq中，某些spider由于各种原因(数据库连接获得不到，内存无法分配等)可能没有执行成功;
    # 需要重新安排状态为waiting的spider再去爬取
    def reschedule_waiting_to_run
      spiders = Spider.where(status: Spider::STATUS[:waiting])
      spiders.find_each { |spider| spider.schedule_to_run } 
    end

    # 重新安排waiting的公司爬虫再去爬取
    def reschedule_company_waiting_to_run
      spiders = Spider.where(status: Spider::STATUS[:waiting], sponsor_type: 'Company')
      spiders.find_each { |spider| spider.schedule_to_run } 
    end
  end

  def run(options = {})
    opts = options.dup.symbolize_keys.reverse_merge stale_days: 1, only_crawl: [:idinfo, :court]
    print "system is runing spider -> ##{self.id} ..." 
    puts opts
    if stale? opts[:stale_days]
      start
      crawl opts[:only_crawl]
      complete
      after_complete
    else
      puts "already new crawled @ #{self.last_crawled_at}."
    end
  end

  def start
    switch_running
  end

  def crawl(crawl_sources_arg = [:idinfo, :court])
  end

  def complete
    switch_complete
  end

  def after_complete
    process_data
    send_faye_channel
  end

  def process_data
    self.data.keys.each do |resource|
      send("process_#{resource}_data")
    end
  end

  def send_faye_channel
  end

  def switch_running
    self.status = STATUS[:running]
    self.save
  end

  def switch_complete
    self.status = STATUS[:complete]
    self.last_crawled_at = DateTime.now
    self.save
  end

  def schedule_to_run
    SpiderWorker.perform_async(self.id)
  end

  def re_schedule_to_run(options = {})
    SpiderWorker.perform_async(self.id, options)
  end

  def stale?(days = 1)
    crawled_exceed days
  end

  # 上次抓取到现在是否超过了多少天
  def crawled_exceed(days = 1)
    if last_crawled_at
      DateTime.now > last_crawled_at + days.day 
    else
      true
    end
  end

  private
  # Crawled court crime attrs:
  #   :party_id [delete]
  #   :party_name
  #   :card_number => :party_number
  #   :case_id
  #   :reg_date
  #   :regist_date
  #   :case_state
  #   :apply_money
  #   :court_name
  #   :orig_url
  def extract_crime_attrs(crawled_attrs) 
    crime_attrs = crawled_attrs.dup
    crime_attrs.symbolize_keys!
    crime_attrs[:party_number] = crime_attrs.delete(:card_number)
    
    crime_attrs.extract!(*VALID_CRIME_ATTRIBUTES)
  end

  # Crawled idinfo cert attrs:
  #  :regist_id
  #  :name
  #  :address
  #  :owner  => :owner_name
  #  :regist_capital
  #  :paid_in_capital
  #  :company_type
  #  :found_date
  #  :business_scope
  #  :business_start_date
  #  :business_end_date
  #  :regist_org
  #  :approved_date
  #  :check_years
  #  :orig_url
  def extract_cert_attrs(crawled_attrs)
    cert_attrs = crawled_attrs.dup
    cert_attrs.symbolize_keys!
    cert_attrs[:owner_name] = cert_attrs.delete(:owner)

    cert_attrs.extract!(*VALID_CERT_ATTRIBUTES)
  end

end
