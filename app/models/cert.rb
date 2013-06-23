#encoding: utf-8
class Cert < ActiveRecord::Base
  attr_accessible :regist_id,            #330481000067480
                  :name,                 #海宁市帝诺纺织有限公司东谷分公司
                  :address,              #海宁市许村镇永福村东谷里南埭37号
                  :owner_name,           #陈凤义
                  :regist_capital,       #3万元人民币
                  :paid_in_capital,      #3万元人民币
                  :company_type,         #有限责任公司
                  :found_date,           #"2011-09-13"
                  :business_scope,       #东风日产品牌汽车、启辰品牌汽车、汽车零
                  :business_start_date,  #"2011-09-13"
                  :business_end_date,    #"2026-09-12"
                  :regist_org,           #海宁市工商行政管理局
                  :approved_date,        #"2011-09-13"
                  :check_years,          #"11"
                  :orig_url,             #http://www.idinfo.cn/SignHandle?user...
                  :regist_capital_amount  # 注册资本有美元和人民币等，这个值是换算成人民币后的数值，用于统计


  #validates :name, presence: true, uniqueness: true
  belongs_to :company

  def business_period
    "#{business_start_date.present? ? business_start_date : '?'} 
    至 #{business_end_date.present? ? business_end_date : '?'}"
  end

  def get_snapshot
    path = Snapshot::Idinfo.new(orig_url: self.orig_url,id: self.id).run
    if path
      self.snapshot_path = path
      self.snapshot_at = Time.now
      self.save
    end
  end

  def regist_capital=(capital)
    super(capital) 

    rate = 6.2

    self.regist_capital_amount = 
      if capital =~ /美元/ 
        capital.to_f * rate
      else
        capital.to_f
      end

    regist_capital
  end

  # === Parameters
  # * value 
  #   is a string or decimal instance
  # def regist_capital=(value)
  #   self.regist_capital_num = value.to_f if value.present?
  #   super(value)
  # end
end
