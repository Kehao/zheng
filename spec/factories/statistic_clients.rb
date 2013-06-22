# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :statistic_client, :class => 'Statistic::Client' do
    micro "MyString"
  end
end
