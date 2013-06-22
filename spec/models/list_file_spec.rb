#encoding: utf-8
require 'spec_helper'

describe ListFile do
  let!(:user) { create(:user) }
  let!(:list_file) { create(:list_file, user: user) }

  describe "#import" do
    before do
      @company = user.companies.create(name: "杭州盛华皮衣有限公司", number: 330182000035091, code: "70428744-1")
      @owner = @company.create_owner(name: "鲍忠弟", number: "330126195202280310")
      list_file.import
    end
    it "should not create companies if already exist" do
      Company.where(name: @company.name).should have(1).item
    end
    it "should not create owner if already exist" do
      Person.where(name: @owner.name, number: @owner.number).should have(1).item
    end
    it "should add company to user client if company exist but not a user client" do
      user.companies.exists?(name: "杭州盛华皮衣有限公司").should be_true
    end
    it "should create company and add to user clients" do
      Company.should have(9).items
      user.companies.should have(9).items
    end
    it "should create person add add to company owner" do
      Person.should have(9).items
      Company.all.map { |company| 
        company.owner.should_not be_nil 
      }
    end
  end
end
