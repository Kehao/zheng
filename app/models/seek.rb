#encoding: utf-8
class Seek < ActiveRecord::Base
  attr_accessible :company_name, :company_number, :person_name, :person_number, :crawled
  normalize_attributes :company_name, :company_number, :person_name, :person_number

  validates_uniqueness_of :company_name, :scope => [:company_number, :person_name, :person_number] 
  validate :should_present_seek_content
  
  has_many :user_seeks
  has_many :users, through: :user_seeks

  has_one  :spider, as: :sponsor, dependent: :destroy
  after_commit :generate_spider, on: :create

  def content
    return @content if @content
    @content = {}
    
    [:company_name, :company_number, :person_name, :person_number].each do |attr|
      @content[attr] = self[attr] if self[attr].present?
    end
    
    @content
  end

  private
  def should_present_seek_content
    errors.add(:base, :empty) if [:company_name, :company_number, :person_name, :person_number].all? { |attribute| self[attribute].blank? }
  end

  def generate_spider
    SeekSpider.create(sponsor: self) unless self.crawled
  end
end
