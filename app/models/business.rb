#encoding: utf-8
class Business < ActiveRecord::Base

  attr_accessible *self.attribute_names
  belongs_to :company

  def recount
    sales_arr = Business.all.map(&:income_of_last_year).compact
    if income_of_last_year.present?
      rank = sales_arr.find_all{|i| i > income_of_last_year}.count + 1
      self.sales = rank
      save
    end

    profit_arr = Business.all.map(&:profit_of_last_year).compact
    if profit_of_last_year.present?
      rank = profit_arr.find_all{|i| i > profit_of_last_year}.count + 1
      self.profit = rank
      save
    end
  end

  def txt_of(att)
    case self.send(att)
    when 90..100
      "很好" 
    when 75..89
      "好"
    when 65..74
      "一般"
    when 55..64
      "弱" 
    when 1..54
      "很弱"
    when 0
      "--"
    end 
  end

  def scale_percent
    return 0 if scale.blank?
    rst = (scale + 0.0) / (@@a||=(Cert.count - Cert.where(regist_capital: nil).count))
    rst = 100 - (rst.round(2)*100).to_i
  end
  def scale_score
    100 - (100 - scale_percent) / 2
  end

  def credit_percent
    return 0 if credit.blank?
    rst = (credit + 0.0) / (@@b||=Company.where(court_crawled: true).count)
    rst = 100 - (rst.round(2)*100).to_i
  end
  def credit_score
    100 - (100 - credit_percent) / 2
  end

  def sales_percent
    return 0 if sales.blank?
    rst = (sales + 0.0) / (@@c||=Business.where("sales IS NOT NULL").count)
    rst = 100 - (rst.round(2)*100).to_i
  end
  def sales_score
    100 - (100 - sales_percent) / 2    
  end

  def profit_percent
    return 0 if profit.blank?
    rst = (profit + 0.0) / (@@d||=Business.where("profit IS NOT NULL").count)
    rst = 100 - (rst.round(2)*100).to_i
  end
  def profit_score
    100 - (100 - profit_percent) / 2
  end

  def credit_avg
    arr = [scale_score, credit_score, sales_score, profit_score].compact.reject{|i| i <= 50}
    return 50 if arr.count != 4
    avg = (arr.sum / 4).to_i + 1
  end
  def credit_avg_txt
    case credit_avg
    when 95..100
      "A++"
    when 85..94
      "A+"
    when 80..84
      "A"
    when 75..79
      "B+"
    when 70..74
      "B"
    when 65..69
      "B-"
    when 60..64
      "C+"
    when 55..59
      "C"
    when 51..54
      "C-"
    when 50
      "n/a"
    end
  end
end
