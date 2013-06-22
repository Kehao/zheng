class Statistic::Client < ActiveRecord::Base
  attr_accessible :micro,
    :user_id,
    :region_code,
    :company,
    :company_court,
    :company_court_ok,
    :company_court_closed,
    :company_court_stopped,
    :company_court_other,
    :company_court_processing,
    :seek, 
    
    :from_at,
    :to_at


  belongs_to :client,:class_name=>"User",:foreign_key=>"user_id"

  #reflect_on_association(:client).klass.send :include, RegionCompanyCourt
  
  # User.send :include, RegionCompanyCourt
  
  def +(other)
    self.company_court_ok          += other.company_court_ok 
    self.company_court_closed      += other.company_court_closed 
    self.company_court_stopped     += other.company_court_stopped 
    self.company_court_other       += other.company_court_other
    self.company_court_processing += other.company_court_processing

    self.company_court             += other.company_court
  end

  def calc_company_court
    self.company_court=
    self.company_court_ok + 
    self.company_court_closed +
    self.company_court_stopped + 
    self.company_court_other +
    self.company_court_processing 
  end
end
