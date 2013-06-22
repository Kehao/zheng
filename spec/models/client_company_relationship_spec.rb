# encoding: utf-8
require 'spec_helper'

describe ClientCompanyRelationship do
  describe "验证" do
    before do
      @company = create(:company)
      @client_company_relationship = build(:client_company_relationship, :company => @company)
    end
    it "属性都正确验证通过" do
      @client_company_relationship.should be_valid
    end
    it "公司必须存在" do
      @client_company_relationship.company = nil
      @client_company_relationship.should_not be_valid
    end
    it "一个客户同一个公司同一个关系只能添加一次, 同一个公司可以添加不同的关系" do
      @client_company_relationship.save!
      client_company_relationship = build(:client_company_relationship, :company => @company)
      client_company_relationship.should_not be_valid

      client_company_relationship = build(:client_company_relationship, :company => @company, :relate_type => :sub_company)
      client_company_relationship.should be_valid
    end
    it "关系类型必须存在" do
      @client_company_relationship.relate_type = nil
      @client_company_relationship.should_not be_valid
    end
    it "关系类型必须为正确的类型" do
      @client_company_relationship.relate_type = "error"
      @client_company_relationship.should_not be_valid
    end
    it "占股必须为0-1之间" do
      @client_company_relationship.hold_percent = 1.1
      @client_company_relationship.should_not be_valid

      @client_company_relationship.hold_percent = -1
      @client_company_relationship.should_not be_valid


      @client_company_relationship.hold_percent = "error" 
      @client_company_relationship.should_not be_valid
    end
  end

  describe "Callbacks" do
    let(:company) { create(:company) }
    let(:company2) { create(:company) }
    let(:company3) { create(:company) }
    let(:owner_relationship) { build(:client_company_relationship, :hold_percent => 0.2, :relate_type => :owner, :company => company) }
    let(:shareholder_relationship) { build(:client_company_relationship, :hold_percent => 0.2, :relate_type => :shareholder, :company => company2) }
    let(:sub_company_relationship) { build(:client_company_relationship, :hold_percent => 0.2, :relate_type => :sub_company, :company => company3) }

    it "如果不是股东或者法人，占股属性因该为nil" do
      owner_relationship.save!
      owner_relationship.hold_percent.should == 0.2

      shareholder_relationship.save!
      shareholder_relationship.hold_percent.should == 0.2

      sub_company_relationship.save!
      sub_company_relationship.hold_percent.should == nil
    end
  end
end
