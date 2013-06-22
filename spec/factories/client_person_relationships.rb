# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_person_relationship do
    relate_type  :shareholder
    hold_percent 0.3
  end
end
