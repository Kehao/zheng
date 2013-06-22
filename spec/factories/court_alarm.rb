FactoryGirl.define do
  factory :court_alarm do
    association :subject, :factory => :company
    carriage { {:crime_ids => [1,2,3], :sent_recipient_ids => []} }
  end
end
