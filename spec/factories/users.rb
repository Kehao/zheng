# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password '123456'
    password_confirmation '123456'

    factory :admin do
      name "admin"
      email "admin@example.com"
      association :role, factory: :r_admin
    end

    factory :member do
      name "member"
      email "member@example.com"
      association :role, factory: :r_member
    end

    factory :cs_manager do
      name "cs_manager"
      email "cs_manager@example.com"
      association :role, factory: :r_cs_manager
    end

    factory :cs do
      name "cs"
      email "cs@example.com"
      association :role, factory: :r_cs
    end

    factory :cs_supporter do
      name "cs_supporter"
      email "cs_supporter@example.com"
      association :role, factory: :r_cs_supporter
    end
  end
end
