# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    sequence(:name)   { |n| "Company#{n}"}
    sequence(:number) { |n| "#{n + 1}".rjust(13, '0') }
  end
end
