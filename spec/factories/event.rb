FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Event #{n}" }
    date { Time.current + 1.week }
    location { 'Some Location' }
    description { 'Event description' }
    status { :registered }
  end
end