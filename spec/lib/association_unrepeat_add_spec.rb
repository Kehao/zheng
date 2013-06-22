#encoding: utf-8
require 'spec_helper'

describe AssociationUnrepeatAdd, "collection association不重复添加对象" do
  it "model should respond to unrepeat_add method" do
    ActiveRecord::Base.should respond_to(:unrepeat_add)
  end

  describe "unrepeat_add" do
    let!(:user) { create(:user) }
    let!(:company) { create(:company) }
    let(:seek) { create(:seek) }

    before do
      User.unrepeat_add :seeks,     uniq_keys: [:company_name, :company_number, :person_name, :person_number]
      User.unrepeat_add :companies
      User.unrepeat_add :people,    uniq_keys: [:number]
    end

    it "add by an association instance" do
      user.add_company(company)
      user.companies.should_not be_blank

      user.add_company(company).should be_false
      user.companies.should have(1).item
      
      expect { user.add_company!(company) }.to raise_error(AssociationUnrepeatAdd::AssociationAlreadyExist)
    end

    it "add by an association id" do
      user.add_company(company.id)
      user.companies.should_not be_blank

      user.add_company(company.id).should be_false
      user.companies.should have(1).item
      
      expect { user.add_company!(company.id) }.to raise_error(AssociationUnrepeatAdd::AssociationAlreadyExist)
    end

    it "add by an association attrs with custom uniq_keys options" do
      attrs = {name: company.name, number: company.number}
      uniq_keys = [:company_name, :company_number]
      user.add_company(attrs, uniq_keys: uniq_keys)
      user.companies.should_not be_blank

      user.add_company(attrs.merge(owner_name: "other"), uniq_keys: uniq_keys).should == company
      user.companies.should have(1).item

      user.add_company(attrs.merge(owner_name: "other")).should be_new_record
      
      expect { user.add_company!(attrs.merge(owner_name: "other"), uniq_keys: uniq_keys) }.to raise_error(AssociationUnrepeatAdd::AssociationAlreadyExist)
    end

    it "add by an association attrs with predefine uniq_keys and custom override uniq_keys option" do
      user.add_seek(seek)
      user.seeks.should_not be_blank

      attrs = {company_name: seek.company_name, person_name: seek.person_name, crawled: true}
      user.add_seek(attrs).should == seek

      user.add_seek(attrs, uniq_keys: [:crawled]).should be_new_record
    end

    it "add by an association attrs with a block" do
      new_seek = build(:seek)
      attrs = {company_name: new_seek.company_name, person_name: new_seek.person_name}
      user.add_seek(attrs) { |obj| obj.crawled = true }.crawled.should be_true
    end
  end

end

