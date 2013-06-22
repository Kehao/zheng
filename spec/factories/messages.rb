# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    association :recipient, :factory => :user
    association :event,     :factory => :notice
  end
end
