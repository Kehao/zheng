#encoding: utf-8
require 'spec_helper'

describe Company do
  describe "validates" do
    let (:company) { build(:company) }
    it "name should present" do
      company.name = nil
      company.should_not be_valid
      company.should have(1).error_on(:name)
    end
    it "name should uniqueness" do
      company.save!

      company1 = build(:company, name: company.name)
      company1.should_not be_valid
      company1.should have(1).error_on(:name)
    end
    it "number should present" do
      company.number = nil
      company.should_not be_valid
      company.should have_at_least(1).error_on(:number)
    end
    it "number should uniqueness" do
      company.save!

      company1 = build(:company, number: company.number)
      company1.should_not be_valid
      company1.should have(1).error_on(:number)
    end

    it "number length should in 13..15 and should be numericality" do
      company.number = '1' * 12 
      company.should_not be_valid
      company.should have(1).error_on(:number)

      company.number = '1' * 16
      company.should_not be_valid
      company.should have(1).error_on(:number)

      company.number = 'adsfasdf12342'
      company.should_not be_valid
      company.should have(1).error_on(:number)
    end

    it "should skip number validation if create_way is crawled" do
      company.create_way = Company::CREATE_WAY[:crawled]
      company.number = "222***"
      company.should be_valid
    end
  end
  
  describe ".create_with_cert" do
    let(:cert) { build(:cert, regist_id: '111***') }

    it "skip number validation if use cert to create company" do
      company = Company.create_with_cert(cert.attributes.extract!("name", "regist_id").symbolize_keys!)
      company.should_not be_new_record
    end
  end

  describe ".seek(seek_params)" do
    let! (:company1) { create(:company) }
    let! (:company2) { create(:company) }

    it "should return exact company if match exactly" do
      companies = Company.seek(company_name: company1.name)
      companies.should have(1).item
      companies.first.should == company1
    end

    it "should return fuzzy match resutl if exactly match return no result" do
      companies = Company.seek(company_name: "Company")
      companies.should have(2).items
    end
    it "can use seek instance as a param" do
      companies = Company.seek(Seek.new(company_name: company1.name))
      companies.should have(1).item
    end
  end

  describe "#number=" do
    let(:company) { build(:company) }
    let(:correct_number) {"330681000092802"}

    it "when number is correct should set region_code from number" do
      company.number = correct_number 
      company.save!
      company.region_code.should == "330681"
    end
    it "when number is not correct, region_code should not set" do
      company.number = "121123123"
      company.region_code.should be_nil

      company.number = "asdf121123123"
      company.region_code.should be_nil
    end
    it "when region_code exist should not set region_code from number" do
      company.region_code = "330100"
      company.number = correct_number
      company.save!
      company.region_code.should == "330100"
    end
  end

  describe "callbacks#after_commit" do
    let(:company) { build(:company) }

    it "should generate a company spider" do
      company.save!

      spider = Spider.where(sponsor_id: company.id, sponsor_type: company.class.name).first
      spider.should be_present
      spider.should be_kind_of(CompanySpider)
    end
  end

  describe "spider should be dependent with company" do
    let!(:company) {create(:company)}

    it "destroy company should destroy spider" do
      company.spider.should_not be_nil
      spider_id = company.spider.id

      company.destroy
      expect { Spider.find(spider_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#alarm_court, 预警公司新的法院信息" do
    def fake_case_id(num=100)
      "(2009)绍诸民执字第#{num}号"
    end
    let(:person)  { create(:person) }
    let(:company) { create(:company, :owner => person) }

    it "generate court alarm when does not exist court alarms" do
      company.crimes.create!(:party_name => company.name, :party_number => company.number, :case_id => fake_case_id, :case_state => "已结")
      company.alarm_court
      company.court_alarms(:reload => true).should have(1).item

      court_alarm = company.court_alarms.first
      court_alarm.crime_ids.should == company.crimes.map(&:id)
    end
    it "generate court alarm when exists court alarms and no updated crimes" do
      crime = company.crimes.create!(:party_name => company.name, :party_number => company.number, :case_id => fake_case_id, :case_state => "已结")
      CourtAlarm.create!(:subject => company, :carriage => {:crime_ids => [crime.id]})

      company.alarm_court
      company.court_alarms.should have(1).item
    end
    it "generate court alarm when exists court alarms and have updated crimes" do
      crime = company.crimes.create!(:party_name => company.name, :party_number => company.number, :case_id => fake_case_id, :case_state => "已结")
      CourtAlarm.create!(:subject => company, :carriage => {:crime_ids => [crime.id]})

      crime = company.crimes.create!(:party_name => company.name, :party_number => company.number, :case_id => fake_case_id(101), :case_state => "已结")
      company.alarm_court

      company.court_alarms.should have(2).items
    end
    it "generate court alarm should inclde owner crimes" do
      crime = person.crimes.create!(:party_name => person.name, :party_number => person.number, :case_id => fake_case_id(102), :case_state => "已结")

      company.alarm_court
      company.court_alarms.should have(1).items
      company.court_alarms.first.crime_ids.should include(crime.id)
    end
  end
end
