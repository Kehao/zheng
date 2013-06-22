#encoding: utf-8
class Person < ActiveRecord::Base
  include ActiveModel::Observing
  include Crimeable
  attr_accessible :name, :number, 
                  :idinfo_crawled, :court_crawled, :sentiment_crawled, 
                  :idinfo_status,  :court_status,  :sentiment_status

  INFO_STATUS = {
    info:      "info",
    success:   "success",
    warning:   "warning",
    important: "important"
  }

  validates :name, :number, presence: true
  validates :number, uniqueness: true, format: {with: /(^\d{15}$)|(^\d{17}([0-9]|X|x)$)/ }

  has_many :companies, foreign_key: :owner_id
  
  has_many :person_clients
  has_many :users, through: :person_clients

  has_one  :spider, as: :sponsor, dependent: :destroy 

  after_commit :generate_spider, on: :create

  def all_crimes
     self.crimes
  end

  def trigger_notify_observers(*args)
    notify_observers(*args)
  end

  def has_problem?
    self.class.problem_court_status.include?(court_status)
  end
  alias_method :problem?, :has_problem?

  #把身份证号的x转换为大写的X, 保证数据库里都为大写X
  def number=(number)
    super(number.try(:upcase))
  end

  # def update
  #   spider.try(:schedule_to_run) || generate_spider
  # end

  def generate_spider
    PersonSpider.create(sponsor: self)
  end
end
