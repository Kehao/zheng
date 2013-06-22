# encoding: utf-8
require 'spec_helper'

describe ClientPersonRelationship do
  describe "验证" do
    before do
      @person = create(:person)
      @client_person_relationship = build(:client_person_relationship, person: @person, person_name: @person.name, person_number: @person.number)
    end
    it "正确的属性验证通过" do
      @client_person_relationship.should be_valid
    end

    it "person_name必须存在" do
      @client_person_relationship.person_name = nil
      @client_person_relationship.should_not be_valid
    end
    it "person_name, person_number同时存在的情况下，对同一个客户同一关系类型必须唯一" do
      @client_person_relationship.save!
      client_person_relationship = build(:client_person_relationship, person_name: @person.name, person_number: @person.number)
      client_person_relationship.should_not be_valid
      client_person_relationship = build(:client_person_relationship, person_name: @person.name, person_number: @person.number)
      client_person_relationship.should_not be_valid
    end

    it "person_id存在的情况下，同一个客户对同一个person_id必须唯一" do
      @client_person_relationship.save!
      client_person_relationship = build(:client_person_relationship, person: @person, person_name: @person.name, person_number: @person.number)
      client_person_relationship.should_not be_valid
    end

    it "关系类型必须存在" do
      @client_person_relationship.relate_type = nil
      @client_person_relationship.should_not be_valid
    end

    it "关系类型必须为正确的类型" do
      @client_person_relationship.relate_type = "error"
      @client_person_relationship.should_not be_valid
    end

    it "占股必须为0-1之间" do
      @client_person_relationship.hold_percent = 1.1
      @client_person_relationship.should_not be_valid

      @client_person_relationship.hold_percent = -1
      @client_person_relationship.should_not be_valid


      @client_person_relationship.hold_percent = "error" 
      @client_person_relationship.should_not be_valid
    end
  end

  describe "#person=" do
    let(:person) { build(:person) }
    let(:client_person_relationship) { build(:client_person_relationship) }

    it "当参数为nil时, 不影响原来的值" do
      old_name = client_person_relationship.person_name
      old_number = client_person_relationship.person_number

      client_person_relationship.person = nil
      client_person_relationship.person_name = old_name
      client_person_relationship.person_name = old_number
    end
    it "当peson_name, person_number不存在值时，自动赋值为person相应的值" do
      client_person_relationship.person_name = nil
      client_person_relationship.person_number = nil

      client_person_relationship.person = person
      client_person_relationship.person_name = person.name
      client_person_relationship.person_number = person.number
    end
    it "当person_name,person_number存在值时，不再赋值" do
      client_person_relationship.person_name = "foo"
      client_person_relationship.person_number = "1234567890"

      client_person_relationship.person = person
      client_person_relationship.person_name = "foo"
      client_person_relationship.person_number = "1234567890"
    end
  end

  describe "Callbacks" do
    let(:person) { build(:person) }
    let(:client_person_relationship) { build(:client_person_relationship, person_name: person.name, person_number: person.number) }

    it "在成功创建后，如果没有相应的person，从person_name, person_number创建相应的person" do
      client_person_relationship.save!
      client_person_relationship.person.should_not be_nil
    end
    it "如果创建person不通过，不影响关联关系的创建" do
      client_person_relationship.person_number = nil
      client_person_relationship.save!
      client_person_relationship.person.should be_new_record
      client_person_relationship.should be_persisted
    end
  end
end

