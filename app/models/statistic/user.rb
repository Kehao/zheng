# encoding: utf-8
module Statistic
  module User
    # === Statistics format
    #
    #  {
    #    total_count:
    #    court_count:
    #    court_percent:
    #  }
    def stats_companies_court
      total_count = self.company_clients.count
      court_count = self.company_clients.problem.count
      closed_or_stoped_or_other_count =self.company_clients.by_court_status(Company.closed_or_stoped_or_other_status_values).count


      statistics = { 
        total_count:   total_count,
        court_count:   court_count,
        closed_or_stoped_or_other_count: closed_or_stoped_or_other_count,
        closed_or_stoped_or_other_percent: cal_percent(closed_or_stoped_or_other_count, total_count),
        court_percent: cal_percent(court_count, total_count)
      }
    end

    def stats_companies_court_by_reg_date(start_month_beginning,end_month_end,include_owner_crimes=true)
      start_month_beginning =  Date.parse(start_month_beginning) unless start_month_beginning.is_a?(Date) 
      end_month_end = Date.parse(end_month_end) unless end_month_end.is_a?(Date) 

      crime_relation = Crime.where("company_clients.user_id = ?",self.id).
        where(:case_state=>"执行中").
        where(:regist_date => start_month_beginning..end_month_end)

      join = "inner join company_clients on crimes.party_id = company_clients.company_id and crimes.party_type = 'Company'"
      crimes = crime_relation.joins(join)
        
      if include_owner_crimes
        join = "inner join companies on companies.owner_id = crimes.party_id and crimes.party_type = 'Person'"
        join += " inner join company_clients on company_clients.company_id = companies.id"
        owner_crimes = crime_relation.joins(join)
        crimes.concat(owner_crimes)
      end

      default = {}
      (start_month_beginning..end_month_end).map {|day| day.to_s =~ /(\d{4})-(\d{2})/;default["#$1-#$2"]=0}

      tmp = {}
      crimes.group_by{|crime|crime.regist_date.to_s =~ /(\d{4})-(\d{2})/;"#$1-#$2"}.each do |day,day_crimes|
        tmp[day] = day_crimes.size
      end

      default.merge(tmp) 
    end

    # === Statistics format
    #
    #   {
    #     city_code: {
    #       name:
    #       total_count:
    #       court_count:
    #       court_percent:
    #     }
    #     ...,
    #     'other': {},
    #     'total': {}
    #   }
    def stats_companies_court_by_area
      return {} if  self.companies.blank?
      region_codes = self.companies.pluck(:region_code).uniq
      areas = region_codes.map { |code| AreaCN.find_by_code(code) }.uniq

      if areas.any?(&:nil?)
        other_area = true
        areas.delete(nil) 
      end
      
      provinces = areas.select(&:province?)
      cities    = areas.select(&:city?)
      districts = areas.select(&:district?)

      cities.concat(districts.map(&:city).uniq).uniq!
      provinces.concat(cities.map(&:province).uniq).uniq!

      statistics = Hash.new { |hash, region_code| hash[region_code] = {} }
      cities.each do |city|
        statistics[city.code][:name] = city.sense_name
        statistics[city.code][:total_count] = self.companies.where("`companies`.`region_code` LIKE '#{city.code.prefix}%'").count
        statistics[city.code][:court_count] = self.companies.problem.where("`companies`.`region_code` LIKE '#{city.code.prefix}%'").count
        statistics[city.code][:court_percent] = cal_percent(statistics[city.code][:court_count], statistics[city.code][:total_count])
      end

      if other_area
        statistics['other'][:name] = '其他'
        if areas.present?
          statistics['other'][:total_count] = self.companies.where("`companies`.`region_code` NOT IN (#{areas.map(&:code).join(',')}) OR `companies`.`region_code` IS NULL").count
          statistics['other'][:court_count] = self.companies.problem.where("`companies`.`region_code` NOT IN (#{areas.map(&:code).join(',')}) OR `companies`.`region_code` IS NULL").count
        else
          statistics['other'][:total_count] = self.companies.count
          statistics['other'][:court_count] = self.companies.problem.count
        end
        statistics['other'][:court_percent] = cal_percent(statistics['other'][:court_count], statistics['other'][:total_count])
      end

      all_total_count = statistics.map { |_, stat| stat[:total_count] }.
                                   inject { |sum, count| sum += count }
      all_court_count = statistics.map { |_, stat| stat[:court_count] }.
                                   inject { |sum, count| sum += count }

      statistics['total'][:name] = '合计'
      statistics['total'][:total_count] = all_total_count
      statistics['total'][:court_count] = all_court_count
      statistics['total'][:court_percent] = cal_percent(all_court_count, all_total_count)

      statistics
    end

    # === Statistics format
    #
    #   {
    #     industry_name: {
    #       total_count:
    #       court_count:
    #       court_percent:
    #     }
    #     ...,
    #     '其他': {},
    #     '合计': {}
    #   }
    def stats_companies_court_by_industry
      return {} if  self.companies.blank?
      industry_ids = self.companies.pluck(:industry_id).uniq

      if industry_ids.any?(&:nil?)
        other_industry = true
        industry_ids.compact!
      end

      industries = Industry.where(:id => industry_ids)

      statistics = Hash.new { |hash, industry_name| hash[industry_name] = {} }

      industries.each do |industry|
        name = industry.name
        statistics[name][:total_count] = self.companies.where(:industry_id => industry.id).count
        statistics[name][:court_count] = self.companies.problem.where(:industry_id => industry.id).count
        statistics[name][:court_percent] = cal_percent(statistics[name][:court_count], statistics[name][:total_count])
      end

      if other_industry
        if industries.present?
          statistics["其他"][:total_count] = self.companies.where("industry_id NOT IN (#{industries.map(&:id).join(',')}) OR industry_id IS NULL").count
          statistics["其他"][:court_count] = self.companies.problem.where("industry_id NOT IN (#{industries.map(&:id).join(',')}) OR industry_id IS NULL").count
        else
          statistics["其他"][:total_count] = self.companies.count
          statistics["其他"][:court_count] = self.companies.problem.count
        end
        statistics["其他"][:court_percent] = cal_percent(statistics["其他"][:court_count], statistics["其他"][:total_count])
      end

      all_total_count = statistics.map { |_, stat| stat[:total_count] }.
                                   inject { |sum, count| sum += count }
      all_court_count = statistics.map { |_, stat| stat[:court_count] }.
                                   inject { |sum, count| sum += count }

      statistics['合计'][:total_count] = all_total_count
      statistics['合计'][:court_count] = all_court_count
      statistics['合计'][:court_percent] = cal_percent(all_court_count, all_total_count)

      statistics
    end

    # === Statistics format
    #
    #   {
    #     total_count:
    #     company_count:
    #     owner_count:
    #     double_count:
    #
    #     company_percent:
    #     owner_percent:
    #     double_percent:
    #   }
    def stats_companies_court_by_owner
      total_count = self.companies.problem.count

      company_problem_count = self.companies.problem(:include_owner => false).count
      owner_problem_count   = self.companies.joins(:owner).where(:people => {:court_status => Company.problem_court_status_values}).count
      double_problem_count  = self.companies.joins(:owner).where(:companies => {:court_status => Company.problem_court_status_values}).
                                                           where(:people => {:court_status => Person.problem_court_status_values}).count

      statistics = {
        total_count:   total_count,
        company_count: company_problem_count,
        owner_count:   owner_problem_count,
        double_count:  double_problem_count,

        company_percent: cal_percent(company_problem_count, total_count),
        owner_percent:   cal_percent(owner_problem_count, total_count),
        double_percent:  cal_percent(double_problem_count, total_count)
      }
    end

    # === Statistics format
    #
    # [
    #   total_count,
    #   { 
    #     count1: number1,
    #     count2: number2
    #   }
    # ]
    def stats_companies_court_by_execute_count
      total_count = self.companies.problem.count

      company_owner_ids = self.companies.problem.map { |c| [c.id, c.owner_id] }

      statistics = Hash.new { |hash, count| hash[count] = 0 }
      company_owner_ids.each do |ids|
        count = if ids.compact.length == 2
                  Crime.where("(party_id = ? AND party_type = ?) OR (party_id = ? AND party_type = ?)", ids[0], 'Company', ids[1], 'Person').count
                else
                  Crime.where(:party_id => ids[0], :party_type => 'Company').count
                end

        statistics[count] += 1
      end

      [total_count, statistics]
    end

    

    # === Statistics format
    #
    #   {
    #     count_0:
    #     count_0_10000:
    #     count_10000_100000:
    #     count_100000_500000:
    #     count_500000_1000000:
    #     count_1000000_3000000:
    #     count_3000000_5000000:
    #     count_greater_than_5000000
    #   }
    def stats_companies_court_by_apply_money
      company_owner_ids = self.companies.problem.map { |c| [c.id, c.owner_id] }

      ids = company_owner_ids.flatten.uniq

      count_0                    = Crime.where(:party_id => ids).where(:apply_money => 0).count
      count_0_10000              = Crime.where(:party_id => ids).where("apply_money > 0 AND apply_money <= 10000").count
      count_10000_100000         = Crime.where(:party_id => ids).where("apply_money > 10000 AND apply_money <= 100000").count
      count_100000_500000        = Crime.where(:party_id => ids).where("apply_money > 100000 AND apply_money <= 500000").count
      count_500000_1000000       = Crime.where(:party_id => ids).where("apply_money > 500000 AND apply_money <= 1000000").count
      count_1000000_3000000      = Crime.where(:party_id => ids).where("apply_money > 1000000 AND apply_money <= 3000000").count
      count_3000000_5000000      = Crime.where(:party_id => ids).where("apply_money > 3000000 AND apply_money <= 5000000").count
      count_greater_than_5000000 = Crime.where(:party_id => ids).where("apply_money > 5000000").count

      total_count = count_0 + count_0_10000 + count_10000_100000 + count_100000_500000 + count_500000_1000000 + 
                    count_1000000_3000000 + count_1000000_3000000 + count_3000000_5000000 + count_greater_than_5000000

      statistics = {
        count_0:                    count_0,
        count_0_10000:              count_0_10000,
        count_10000_100000:         count_10000_100000,
        count_100000_500000:        count_100000_500000,
        count_500000_1000000:       count_500000_1000000,
        count_1000000_3000000:      count_1000000_3000000,
        count_3000000_5000000:      count_3000000_5000000,
        count_greater_than_5000000: count_greater_than_5000000,

        count_0_percent:                    cal_percent(count_0                   , total_count),   
        count_0_10000_percent:              cal_percent(count_0_10000             , total_count),
        count_10000_100000_percent:         cal_percent(count_10000_100000        , total_count),
        count_100000_500000_percent:        cal_percent(count_100000_500000       , total_count),
        count_500000_1000000_percent:       cal_percent(count_500000_1000000      , total_count),
        count_1000000_3000000_percent:      cal_percent(count_1000000_3000000     , total_count),
        count_3000000_5000000_percent:      cal_percent(count_3000000_5000000     , total_count),
        count_greater_than_5000000_percent: cal_percent(count_greater_than_5000000, total_count)
      }
    end

    # === Statistics format
    #
    #   {
    #      '2011-1-1': count,
    #      '2011-1-2': count,
    #      '2011-1-3': count,
    #      ...
    #   }
    def stats_companies_court_by_reg_date2
      company_owner_ids = self.companies.problem.map { |c| [c.id, c.owner_id] }

      ids = company_owner_ids.flatten.uniq

      today = Date.today
      last_year = today.year - 1

      last_year_month_beginnings = (1..12).map { |month| Date.new(last_year, month, 1) }
      this_year_month_beginnings = (1..today.month).map { |month| Date.new(today.year, month, 1) }

      month_beginnings = last_year_month_beginnings.concat(this_year_month_beginnings)

      statistics = {}
      month_beginnings.each do |beginning|
        beginning.to_s =~/(\d{4})-(\d{2})/ 
        statistics["#$1-#$2"] = Crime.where(:party_id => ids).where(:regist_date => beginning..beginning.end_of_month).count
      end

      statistics
    end

    # === Statistics format
    #
    #   {
    #     '330100' => {
    #       :name => "杭州市", 
    #       :count => 100,
    #       :stats => {
    #         '330101' => {
    #           :name => "滨江区",
    #           :count => 10,
    #           :percent => 10%
    #         },
    #         '330102' => {
    #
    #         }
    #       }
    #     }
    #   }
    def stats_companies_court_by_area_detail
      region_codes = self.companies.problem.map(&:region_code).uniq
      areas = region_codes.map { |code| AreaCN.find_by_code(code) }.uniq

      if areas.any?(&:nil?)
        other_area = true
        areas.delete(nil) 
      end
      
      provinces = areas.select(&:province?)
      cities    = areas.select(&:city?)
      districts = areas.select(&:district?)

      cities.concat(districts.map(&:city).uniq).uniq!
      provinces.concat(cities.map(&:province).uniq).uniq!

      statistics = Hash.new { |hash, key| hash[key] = {} }
      districts.each do |district|
        district_statistics = Hash.new { |hash, key| hash[key] = {} }
        district_statistics[district.code][:count] = self.companies.problem.where(:region_code => district.code).count
        district_statistics[district.code][:name]  = district.sense_name

        city = district.city
        statistics[city.code][:name]  ||= city.sense_name
        statistics[city.code][:stats] ||= {}
        statistics[city.code][:stats].merge!(district_statistics)
      end

      statistics.each do |city_code, city_stats|
        statistics[city_code][:count] = city_stats[:stats].inject(0) { |sum, district_stats| sum += district_stats[1][:count] }

        city_stats[:stats].each do |district_code, district_stats|
          district_stats[:percent] = cal_percent(district_stats[:count], statistics[city_code][:count])
        end
      end

      statistics
    end

    def status_baic_companies(group_by)
      result = {:categores =>[],:percent=>[],:count=>[],:total=>[]}
      companies = self.companies.includes(:cert) 
      return result if companies.blank? 

      companies_size = companies.size
      (companies.group_by &group_by).each do |type_name,comps|
        type_name = "未知" unless type_name

        result[:categores] << type_name 
        result[:count] << comps.size 
        result[:total] << companies_size 
        result[:percent] << percentage(cal_percent(comps.size, companies_size),2) 
      end
      result

    end

    #basic
    def stats_basic_companies_credit
      status_baic_companies(:credit_avg_txt)
    end
    def stats_basic_companies_nature
      status_baic_companies(:company_type)
    end

    def stats_basic_companies_industry
      result = status_baic_companies(:industry_id)
      result[:categores] = result[:categores].map do |categore| 
        if categore.is_a? Integer
          Industry.find(categore).name
        else
          categore
        end
      end
      result
    end

    def stats_basic_company_clients
      result = {}
      return result if self.company_clients.blank?

      self.company_clients.group_by{|company_client|company_client.created_at.year}.each do |year,company_clients|
        result[year] = company_clients.size
      end
      result
    end

    def stats_basic_companies_regist_capital_by_nature
      result = {}
      companies = self.companies.includes(:cert)
      return result if companies.blank?

      (companies.group_by &:company_type).each do |company_type,comps|
        company_type = company_type.blank? ? "未知" : company_type
        total_capital = comps.map { |comp|
          comp.cert && comp.cert.regist_capital_amount || 0
        }.inject &:+

        result[company_type] = total_capital.round(2) 
      end
      result

    end

    def stats_basic_companies_regist_capital_by_industry
      result = {}
      companies = self.companies.includes(:cert)
      return result if companies.blank?

      (companies.group_by &:industry_id).each do |industry_id,comps|
        industry_name = industry_id ? Industry.find(industry_id).name : "未知"
        total_capital = comps.map { |comp|
          comp.cert && comp.cert.regist_capital_amount || 0
        }.inject &:+
        result[industry_name] = total_capital.round(2)
      end
      result
    end

    def stats_basic_companies_regist_capital_yearly
      result = {}
      company_clients = self.company_clients.includes(:company,:company=>:cert)
      return result if company_clients.blank?

      company_clients.group_by{|company_client|company_client.created_at.year}.each do |year,company_clients|
        total_capital = company_clients.map { |company_client|
           company_client.company.cert && company_client.company.cert.regist_capital_amount || 0
        }.inject &:+
          result[year] = total_capital.round(2)
      end
      result
    end

    #business
    def stats_business_average_companies_yearly(attr)
      result = {"前年"=>0,"去年"=>0,"今年" =>0}
      companies = yield 
      return result if companies.blank?

      total = { "the_year_before_last" => 0, "last_year" => 0, "this_year" => 0 }
      companies.each do |company|
        if company.business
          attr_value_of_the_year_before_last = company.business.public_send("#{attr}_of_the_year_before_last") 
          if attr_value_of_the_year_before_last && !attr_value_of_the_year_before_last.zero?
            result["前年"] += attr_value_of_the_year_before_last 
            total["the_year_before_last"] += 1
          end

          attr_value_of_last_year = company.business.public_send("#{attr}_of_last_year") 
          if  attr_value_of_last_year && !attr_value_of_last_year.zero?
            result["去年"] += attr_value_of_last_year 
            total["last_year"] += 1
          end

          attr_value_of_this_year = company.business.public_send("#{attr}_of_this_year") 
          if  attr_value_of_this_year && !attr_value_of_this_year.zero?
            result["今年"] += attr_value_of_this_year 
            total["this_year"] += 1
          end
        end
      end
      result["前年"] = cal_percent(result["前年"],total["the_year_before_last"],2) 
      result["去年"] = cal_percent(result["去年"],total["last_year"],2) 
      result["今年"] = cal_percent(result["今年"],total["this_year"],2) 

      result
    end

    def stats_business_average_companies_worker_number_yearly
      stats_business_average_companies_yearly :worker_number do
        self.companies.includes(:business)
      end
    end

    def stats_business_average_companies_by_nature_yearly(attr)
      result = {}
      companies = self.companies.includes(:business)
      return result if companies.blank?

      (companies.group_by &:company_type).each do |company_type,comps|

        company_type = company_type.blank? ? "未知" : company_type
        result[company_type] = (stats_business_average_companies_yearly attr do comps end)
      end
      result
    end

    def stats_business_average_companies_by_industry_yearly(attr)
      result = {}
      companies = self.companies.includes(:business)
      return result if companies.blank?

      (companies.group_by &:industry_id).each do |industry_id,comps|
        industry_name = industry_id ? Industry.find(industry_id).name : "未知"
        result[industry_name] = (stats_business_average_companies_yearly attr do comps end)
      end
      result
    end

    def stats_business_companies_total_yearly(attr)
      result = {"前年"=>0,"去年"=>0,"今年" =>0}
      companies = self.companies.includes(:business)
      return result if companies.blank?

      companies.map do |company| 
        if company.business
          result["前年"] += (company.business.public_send("#{attr}_of_the_year_before_last") || 0)
          result["去年"] += (company.business.public_send("#{attr}_of_last_year") || 0)
          result["今年"] += (company.business.public_send("#{attr}_of_this_year") || 0)
        end
      end
      result
    end


    #business income
    def stats_business_average_companies_income_by_nature_yearly
      stats_business_average_companies_by_nature_yearly(:income)
    end

    def stats_business_average_companies_income_by_industry_yearly
      stats_business_average_companies_by_industry_yearly(:income)
    end

    def stats_business_companies_income_total_yearly
      stats_business_companies_total_yearly(:income)
    end

    #business assets
    def stats_business_average_companies_assets_by_nature_yearly
      stats_business_average_companies_by_nature_yearly(:assets)
    end

    def stats_business_average_companies_assets_by_industry_yearly
      stats_business_average_companies_by_industry_yearly(:assets)
    end

    def stats_business_companies_assets_total_yearly
      stats_business_companies_total_yearly(:assets)
    end
    
    #business profit
    def stats_business_average_companies_profit_by_nature_yearly
      stats_business_average_companies_by_nature_yearly(:profit)
    end

    def stats_business_average_companies_profit_by_industry_yearly
      stats_business_average_companies_by_industry_yearly(:profit)
    end

    def stats_business_companies_profit_total_yearly
      stats_business_companies_total_yearly(:profit)
    end
  
    private
    def cal_percent(dividend, divisor, precision = 4)
      divisor != 0 ? (dividend / divisor.to_f).round(precision) : 0
    end

    def percentage(f, precision = 0)
      (f * 100).round(precision)
    end

  end
end



# ========================================
#  取出数据进行统计
# ========================================
#  def stats_companies_by_area
#    area_companies = Hash.new { |hash, key| hash[key] = [] }
#
#    self.companies.find_each do |company|
#      area_companies[company.region_code] << company
#    end
#
#    statistics = Hash.new { |hash, region_code| hash[region_code] = {} }
#
#    # stats total count
#    area_companies.keys.each do |region_code|
#      area = AreaCN.find_by_code(region_code)
#      statistics[region_code][:name] = area.try(:name) || "其他"
#      statistics[region_code][:total_count] = area_companies[region_code].count
#
#      court_companies = area_companies[region_code].select(&:has_problem?)
#
#      statistics[region_code][:court_count] = court_companies.count
#      statistics[region_code][:court_percent] = statistics[region_code][:court_count] / statistics[region_code][:total_count].to_f
#    end
#
#    statistics
#  end
#
#  def stats_companies_by_industry
#    industry_companies = Hash.new { |hash, key| hash[key] = [] }
#
#    self.companies.find_each do |company|
#      industry = company.industry_name || "其他"
#      industry_companies[industry] << company
#    end
#
#    statistics = Hash.new { |hash, key| hash[key] = {} }
#    industry_companies.keys.each do |industry|
#      statistics[industry][:total_count] = industry_companies[industry].count
#
#      court_companies = industry_companies[industry].select(&:has_problem?)
#
#      statistics[industry][:court_count] = court_companies.count
#      statistics[industry][:court_percent] = statistics[industry][:court_count] / statistics[industry][:total_count].to_f
#    end
#
#    statistics
#  end
#
#  def stats_companies_by_owner
#    party_company_count = 0
#    party_owner_count = 0
#    party_all_count = 0
#
#    total_count = self.problem_companies.count
#
#    self.problem_companies.find_each do |company|
#      if company.crimes.count == company.all_crimes.count 
#        company_count += 1
#      elsif company.crimes.count == 0 && company.all_crimes.count != 0
#        owner_count += 1
#      else company.crimes.count !=0 && company.crimes.count != company.all_crimes.count
#        company_count += 1
#        owner_count += 1
#        all_count += 1
#      end
#    end
#
#    statistics = {
#      party_company: {count: party_company_count, percent: party_company_count / total_count.to_f},
#      party_owner:   {count: party_owner_count, percent: party_owner_count / total_count.to_f}
#      party_all:     {count: party_all_count, percent: party_all_count / total_count.to_f}
#    }
#  end
#
#  def stats_companies_by_court_count
#    crimes_count = Hash.new { |hash, key| hash[key] = 0 }
#
#    self.problem_companies.find_each do |company|
#      crimes_count[company.all_crimes.count] += 1
#    end
#
#    crimes_count
#  end
#
#  def stats_crimes_by_apply_money
#    money_range_text = { 
#      0..0             => "0",
#      0..10000         => "0-1万",
#      10000..100000    => "1-10万",
#      100000..500000   => "10-50万",
#      500000..1000000  => "50-100万",
#      1000000..3000000 => "100-300万",
#      3000000..5000000 => "300-500万"
#    } 
#
#    statistics = {
#      "0"         => {count: 0},    
#      "0-1万"     => {count: 0},  
#      "1-10万"    => {count: 0},
#      "10-50万"   => {count: 0},
#      "50-100万"  => {count: 0}, 
#      "100-300万" => {count: 0},
#      "300-500万" => {count: 0},
#      "500万以上" => {count: 0} 
#    }
#
#
#    self.problem_companies.find_each do |company|
#      company.all_crimes.each do |crime|
#        range_text = money_range_text.detect do |money_range, text|
#          apply_money = crime.apply_money.to_f rescue 0
#          money_range.include?(apply_money)
#        end
#
#        name = range_text ? range_text[1] : "500万以上"
#        statistics[name][:count] += 1
#      end
#    end
#
#    total_count = statistics.values.map { |stats| stats[:count]}.
#                                    inject { |sum, count| sum += count }
#
#    statistics.values.each do |stats|
#      stats[:percent] = stats[:count] / total_count.to_f
#    end
#
#    statistics
#  end
