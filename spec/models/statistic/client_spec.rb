#encoding: utf-8
require 'spec_helper'

describe Statistic::Client do
  let(:member){create(:member)}

  before do
    Company.attr_accessible  :water_crawled, 
      :power_crawled, 
      :sentiment_crawled, 
      :owner_id, 
      :water_status, 
      :power_status, 
      :sentiment_status, 
      :create_way, 
      :industry_id, 
      :apollo_order_status, 
      :apollo_black, 
      :created_at, 
      :updated_at
    @company_options = 
      {
      name: "Company-name", 
      number: "330108*****", 
      idinfo_crawled: true, 
      court_crawled: true, 
      water_crawled: false, 
      power_crawled: false, 
      sentiment_crawled: false, 
      owner_id: nil, 
      owner_name: "马云", 
      idinfo_status: "success", 
      court_status: "ok", 
      water_status: nil, 
      power_status: nil, 
      sentiment_status: nil, 
      code: nil, 
      create_way: 1, 
      region_code: "1", 
      industry_id: nil, 
      apollo_order_status: nil, 
      apollo_black: nil,
      created_at: "2012-10-10 03:09:42", 
      updated_at: "2012-10-24 08:40:44"
    }
    @court_statuses=["ok","closed","stopped","processing","other"]
    @region_codes  = ["330100","330108","330101",nil]
    @created_at = [Time.now,1.days.ago,2.days.ago,4.days.ago]
    Statistic::Client.delete_all
    (1..50).each do |i|
      member.companies.create(@company_options.merge(
        name: "Company-name-#{i}",
        number: "330108#{i}****",
          court_status: @court_statuses[rand(5)],
          region_code: @region_codes[rand(4)],
          created_at: @created_at[rand(4)]
      ))
    end
  end

  context "RegionCompanyCourt" do
    it "report_daily" do
      member.companies.count.should == 50
      member.report_daily(Date.today)

      today_companies = member.companies.where(:created_at=>Date.today.beginning_of_day..Date.today.end_of_day)
      region = today_companies.map{|c| c.region_code}.uniq

      scs = Statistic::Client.where(:from_at=>Date.today.beginning_of_day,:to_at=>Date.today.end_of_day)
      scs.count.should == (region.size + 1)

      @court_statuses.each do |status|
        today_status_companies = today_companies.select{|c| c.court_status == status}
        today_330100_status_companies = today_status_companies.select{|c|c.region_code == "330100"}.size
        today_330108_status_companies = today_status_companies.select{|c|c.region_code == "330108"}.size
        today_330101_status_companies = today_status_companies.select{|c|c.region_code == "330101"}.size
        today_nil_status_companies = today_status_companies.select{|c|c.region_code == nil}.size

        if sc_330100 = scs.each.detect{|sc|sc.region_code == "330100"}
          sc_330100.send("company_court_#{status}").should == today_330100_status_companies
        end
        if sc_330108 = scs.each.detect{|sc|sc.region_code == "330108"} 
          sc_330108.send("company_court_#{status}").should == today_330108_status_companies
        end
        if sc_330101 = scs.each.detect{|sc|sc.region_code == "330101"} 
          sc_330101.send("company_court_#{status}").should == today_330101_status_companies
        end
        if sc_000000 = scs.each.detect{|sc|sc.region_code == "000000"}
          sc_000000.send("company_court_#{status}").should == today_nil_status_companies
        end
        status_total = today_330100_status_companies + today_330108_status_companies + today_330101_status_companies + today_nil_status_companies
        scs.each.detect{|sc|sc.region_code == nil}.send("company_court_#{status}").should == status_total 
      end
    end

    it "report_from_daily" do
      member.report_daily(4.days.ago)
      scs4=Statistic::Client.where(micro: "daily",from_at: 4.days.ago.beginning_of_day).all
      member.report_daily(3.days.ago)
      scs3=Statistic::Client.where(micro: "daily",from_at: 3.days.ago.beginning_of_day).all
      member.report_daily(2.days.ago)
      scs2=Statistic::Client.where(micro: "daily",from_at: 2.days.ago.beginning_of_day).all
      member.report_daily(1.days.ago)
      scs1=Statistic::Client.where(micro: "daily",from_at: 1.days.ago.beginning_of_day).all
      member.report_daily(Date.today)
      scs0=Statistic::Client.where(micro: "daily",from_at: Date.today.beginning_of_day).all

      options = {
        micro: :for_test,
        from_at: 4.days.ago.beginning_of_day,
        to_at: Date.today.end_of_day,
      }
      member.report_from_daily(options)
      scs_for_test= Statistic::Client.where(micro: "for_test",from_at: 4.days.ago.beginning_of_day,to_at:Date.today.end_of_day)

      ["330100","330108","330101","000000"].each do |region|
        region_sc0 = scs0.select{|sc|sc.region_code == region}.first
        region_sc1 = scs1.select{|sc|sc.region_code == region}.first
        region_sc2 = scs2.select{|sc|sc.region_code == region}.first
        region_sc3 = scs3.select{|sc|sc.region_code == region}.first
        region_sc4 = scs4.select{|sc|sc.region_code == region}.first

        region_sc_for_test = scs_for_test.select{|sc|sc.region_code == region}.first

        @court_statuses.each do |status|
          region_status = 0
          if region_sc0
            region_status += region_sc0.send("company_court_#{status}")
          end
          if region_sc1
            region_status += region_sc1.send("company_court_#{status}")
          end
          if region_sc2
            region_status += region_sc2.send("company_court_#{status}") 
          end
          if region_sc3
            region_status += region_sc3.send("company_court_#{status}") 
          end
          if region_sc4
            region_status += region_sc4.send("company_court_#{status}") 
          end

          region_sc_for_test.send("company_court_#{status}").should == region_status 
        end
      end
    end

    it "report_weekly_from_day_to_day" do
      member.companies.destroy_all
      Company.delete_all
      #20121001 周一 10月有31天
      first_week_monday = "20121001".to_date.beginning_of_week
      first_week_sunday = first_week_monday.end_of_week 

      second_week_monday= first_week_monday.next_week
      second_week_sunday = second_week_monday.end_of_week 

      third_week_monday = second_week_monday.next_week
      third_week_sunday = third_week_monday.end_of_week 

      (1..30).each do |i|
        member.companies.create(@company_options.merge(
          name: "Company-name-#{i}",
          number: "330108#{i}****",
            court_status: @court_statuses[rand(5)],
            region_code: @region_codes[rand(4)],
            created_at:  (first_week_monday..first_week_sunday).to_a[rand(7)].beginning_of_day))
      end
      (31..60).each do |i|
        member.companies.create(@company_options.merge(
          name: "Company-name-#{i}",
          number: "330108#{i}****",
            court_status: @court_statuses[rand(5)],
            region_code: @region_codes[rand(4)],
            created_at:  (second_week_monday..second_week_sunday).to_a[rand(7)].beginning_of_day))
      end
      (61..90).each do |i|
        member.companies.create(@company_options.merge(
          name: "Company-name-#{i}",
          number: "330108#{i}****",
            court_status: @court_statuses[rand(5)],
            region_code: @region_codes[rand(4)],
            created_at:  (third_week_monday..third_week_sunday).to_a[rand(7)].beginning_of_day))
      end
      member.companies.size.should == 90

      (first_week_monday..(first_week_monday.end_of_month)).each do |day|
        member.report_daily(day)
      end
      #member.weekly_company_report(first_week_monday)
      #member.weekly_company_report(second_week_monday)
      #member.weekly_company_report(third_week_monday)
      member.report_monthly(first_week_monday)
      member.weekly_from_day_to_day(first_week_monday,first_week_monday.end_of_month)

      week_scs  = Statistic::Client.where(:micro=>"weekly")
      month_scs = Statistic::Client.where(:micro=>"monthly")
      #week_scs.each do |sc|
      #  p "===="
      #  p sc
      #end
      #month_scs.each do |sc|
      #  p "-----"
      #  p sc
      #end
      ["330100","330108","330101","000000"].each do |region|
        region_w1_scs = week_scs.select{|sc|sc.region_code == region}
        temp = 0
        region_w1_scs.each do |sc|
          temp += sc.send("company_court_ok") if sc
        end
        region_m_scs = month_scs.select{|sc|sc.region_code == region}.first

        region_m_scs.company_court_ok.should == temp

      end


    end
  end
end
