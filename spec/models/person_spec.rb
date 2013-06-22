require 'spec_helper'

describe Person do
  describe "validates" do
    let (:person) { build(:person) }

    it "correct attributes should be valid" do
      person.should be_valid
    end
    it "name should present" do
      person.name = nil
      person.should have_at_least(1).error_on(:name)
    end
    it "number should present" do
      person.number = nil
      person.should have_at_least(1).error_on(:number)
    end
    it "number should be uniqueness" do
      person.save!

      person1 = build(:person, number: person.number)
      person1.should have_at_least(1).error_on(:number)
    end
    it "number format should be valid" do
      person.number = '1121232141231'
      person.should have_at_least(1).error_on(:number)
    end
  end
end
