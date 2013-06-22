# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notice do
    carriage { {:crime_ids => [1,2,3]} }
    type     'CourtAlarm'
  end
end
