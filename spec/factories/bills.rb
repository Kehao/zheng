# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    amount 1
    cost 1
    record_time "2012-08-24 17:39:52"
    paid false
    last_number "MyString"
    this_number "MyString"
  end
end
