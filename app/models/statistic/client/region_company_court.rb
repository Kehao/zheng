module Statistic
  class Client
    module RegionCompanyCourt
      include Statistic::Report

      def self.included(client)
        client.has_many :statistic_clients,:class_name=>"Statistic::Client"
      end

      def report_from_daily(options)
        rs=ActiveRecord::Base.connection.execute(
          "SELECT"+
          " SUM(s.`company_court`) AS sum_company_court,"+
          "SUM(s.`company_court_ok`) AS sum_company_court_ok,"+
          "SUM(s.`company_court_closed`) AS sum_company_court_closed,"+
          "SUM(s.`company_court_stopped`) AS sum_company_court_stopped,"+
          "SUM(s.`company_court_processing`) AS sum_company_court_processing,"+
          "SUM(s.`company_court_other`) AS sum_company_court_other,"+
          "s.`region_code` AS region_code"+
          " FROM `statistic_clients` s"+
          " WHERE s.`micro`='daily'"+
          " AND s.`from_at` BETWEEN '#{options[:from_at].to_s(:db)}' AND '#{options[:to_at].to_s(:db)}'"+
          " GROUP BY region_code") 
          unless rs.any? 
            return self.statistic_clients.create(options)
          end
          rs.each do |row|
            statistic = self.statistic_clients.new(options.merge(
              :company_court => row[0].to_i,
              :company_court_ok => row[1].to_i,
              :company_court_closed => row[2].to_i,
              :company_court_stopped => row[3].to_i,
              :company_court_processing => row[4].to_i,
              :company_court_other => row[5].to_i,
              :region_code => row[6] ))

              statistic.save 
          end
      end

      def report_daily_from_record(options)
        result = self.companies.where( :created_at=>options[:from_at]..options[:to_at]).group(:region_code,:court_status).count
        if result.blank?
          return self.statistic_clients.create(options.merge(
            :region_code => nil
          ))
        end

        statistics = Hash.new
        result.each do |r|
          r_region_code = r[0][0] || "000000"
          r_status=Company.court_status.find_value(r[0][1])
          r_status_count = r[1]

          statistics[r_region_code] ||= self.statistic_clients.new(options.merge(
            :region_code=>r_region_code
          ))

          statistics[r_region_code].send("company_court_#{r_status}=",r_status_count)  
        end

        total = self.statistic_clients.new(options.merge(
          :region_code => nil
        ))

        statistics.values.each do |statistic|
          statistic.calc_company_court
          statistic.save
          total + statistic 
        end
        total.save
      end

    end
  end
end

