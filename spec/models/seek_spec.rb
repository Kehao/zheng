require 'spec_helper'

describe Seek do
  describe "validates" do
    let(:seek) { build(:seek) }

    it "should unique with company_name, company_number, person_name, person_number" do
      seek.save!

      new_seek = Seek.new
      new_seek.company_name = seek.company_name
      new_seek.company_number = seek.company_number
      new_seek.person_name = seek.person_name
      new_seek.person_number = seek.person_number

      new_seek.should_not be_valid
      new_seek.should have(1).error_on(:company_name)
    end

    it "should present seek content" do
      seek.should be_valid

      blank_seek = Seek.new
      blank_seek.should have(1).error_on(:base)
    end
  end

  describe "callbacks" do
    context "after_commit " do
      let(:seek) { build(:seek) }

      it "should generate a seek spider if not crawled" do
        seek.save!
        spider = Spider.where(sponsor_id: seek.id, sponsor_type: seek.class.name).first
        spider.should be_present
        spider.should be_kind_of(SeekSpider)
      end
      it "should not generate spider if crawled" do
        seek.crawled = true
        seek.save!
        Spider.where(sponsor_id: seek.id, sponsor_type: seek.class.name).should be_blank
      end
    end
  end

  describe "normalize_attributes" do
    it "should normalize company_name, company_number, person_number, person_name" do
      seek = Seek.new(
        company_name: "  qqw  ",
        company_number: "  123",
        person_name: ' fang ',
        person_number: " 12121212"
      )
      seek.company_name.should == 'qqw'
      seek.company_number.should == '123'
      seek.person_name.should == 'fang'
      seek.person_number.should == '12121212'
    end
  end
end
