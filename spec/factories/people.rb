# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    sequence(:name) { |n| "Person#{n}"}
    sequence(:number) { |n| "#{n + 1}".rjust(18, '3')}
  end
end
