#encoding: utf-8
require 'spec_helper'

describe User do
  let(:admin)   {create(:admin)}

  before do
    @exist_company = Company.create(
      name: "杭州盛华皮衣有限公司", 
      number: 330182000035091, 
      code: "70428744-1"
    )
  end

  it "create_company_client_with_company_and_company_owner: nil/blank" do
    company_attrs_nil = nil
    company_attrs_blank = {}

    [company_attrs_nil,company_attrs_blank].each do |arrts|
      expect{
        expect{
        company_client = admin.create_company_client_with_company_and_company_owner(arrts)
        company_client.errors[:company_id].should_not be_nil
        company_client.company.errors[:name].should_not be_nil
      }.to change(Company, :count).by(0)
      }.to change(CompanyClient, :count).by(0)
    end

  end

  it "create_company_client_with_company_and_company_owner: company_attrs_exist" do
    company_attrs_exist = {
      company: { 
      name: "杭州盛华皮衣有限公司"}
    }
    expect{
      expect{
      company_client = admin.create_company_client_with_company_and_company_owner(company_attrs_exist)
      company_client.errors.full_messages.should == []
      company_client.company.errors.full_messages.should == []
    }.to change(Company, :count).by(0)
    }.to change(CompanyClient, :count).by(1)
  end

  it "create_company_client_with_company_and_company_owner: dup company_attrs_exist" do
    company_attrs_exist = {
      company: { 
      name: "杭州盛华皮衣有限公司"}
    }
    admin.companies << @exist_company 
    expect{
      expect{
      company_client = admin.create_company_client_with_company_and_company_owner(company_attrs_exist)
      company_client.errors.full_messages.should == []
      company_client.company.errors.full_messages.should == []
    }.to change(Company, :count).by(0)
    }.to change(CompanyClient, :count).by(0)
  end


  it "create_company_client_with_company_and_company_owner: company_attrs_not_exist" do
    company_attrs_not_exist = { 
      company: {
      name:"not exist company name",
      number: 330182000035013, 
      code: "70428744-11"}
    }
    expect{
      expect{
      company_client = admin.create_company_client_with_company_and_company_owner(company_attrs_not_exist)
      company_client.errors.full_messages.should == []
      company_client.company.errors.full_messages.should == []
    }.to change(Company, :count).by(1)
    }.to change(CompanyClient, :count).by(1)
  end

  it "create_company_client_with_company_and_company_owner: company_attrs_not_exist company not valid" do
    company_attrs_not_exist_company_not_valid = { 
      company: {
      number: 330182000035013, 
      code: "70428744-11"}
    }
    expect{
      expect{
      company_client = admin.create_company_client_with_company_and_company_owner(company_attrs_not_exist_company_not_valid)
      company_client.errors[:company].should_not be_nil 
      company_client.company.errors[:name].should_not be_nil
    }.to change(Company, :count).by(0)
    }.to change(CompanyClient, :count).by(0)
  end

end

# describe "#create_seek(attrs)" do
#   let! (:user) { create(:user) }
#   let (:seek) { create(:seek) }
#   let (:seek_attrs) { {company_name: 'alibaba'}}

#   it "should create seek and add to user seeks if seek attrs all new" do
#     seek = user.create_seek(seek_attrs)
#     seek.should_not be_new_record
#     seek.users.should include(user)
#   end
#   it "should add the seek which exists with the same attrs but not exist in user seeks to user seeks " do
#     user.seeks << seek

#     seek_attrs = {company_name: seek.company_name, company_number: seek.company_number, person_name: seek.person_name, person_number: seek.person_number}
#     seek1 = user.create_seek(seek_attrs)
#     seek1.should == seek
#   end
#   it "should do nothing but return the seek if a seek with same attrs exist in user seeks" do
#     user.seeks.push(seek)

#     seek_attrs = {company_name: seek.company_name, company_number: seek.company_number, person_name: seek.person_name, person_number: seek.person_number}
#     seek1 = user.create_seek(seek_attrs)
#     seek1.should == seek
#   end
# end
