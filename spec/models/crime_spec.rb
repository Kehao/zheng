#encoding: utf-8
require 'spec_helper'

describe Crime do
  let!(:company) { create(:company) }
  
  before do
    @crimes = [create(:crime), create(:crime, :case_id => "test2", :case_state => "执行中"), create(:crime, :case_id => "test3", :case_state => "终止执行")]
    @crimes.each do |crime|
      company.add_crime(crime)
    end
  end

  it "add crimes should update party court_status" do
    company.reload
    company.court_status.should be_processing
  end

  it "update crimes should update party court_status" do
    @crimes[1].update_attributes_if_change(:case_state => "已结")
    company.reload
    company.court_status.should be_stopped

    @crimes.last.update_attributes_if_change(:case_state => "已结")
    company.reload
    company.court_status.should be_closed

    @crimes[1].case_state = "执行中"
    @crimes[1].save
    company.reload
    company.court_status.should be_processing
  end

  it "use party= update party should update party court_status" do
    crime = create(:crime, :case_id => "test4", :case_state => "终止执行")
    company1 = create(:company)
    crime.party = company1
    crime.save

    company1.reload
    company1.court_status.should be_stopped
  end

  it "use crimes<<() should update party court status" do
    crime = create(:crime, :case_id => "test4", :case_state => "终止执行")
    company1 = create(:company)
    company1.crimes << crime

    company1.reload
    company1.court_status.should be_stopped
  end

  it "update crime other attributes should not update party court status" do
    company.should_not_receive(:update_court_status_through_crimes)
    @crimes.first.update_attributes(:apply_money => "10000.0")
  end

end
