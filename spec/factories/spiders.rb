# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :spider do
  end

  factory :company_spider, parent: :spider do
  end

  factory :person_spider, parent: :spider do
  end

  factory :seek_spider, parent: :spider do
  end
end
