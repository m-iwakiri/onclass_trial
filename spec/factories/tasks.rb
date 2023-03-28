FactoryBot.define do
  factory :task do
    title { Faker::Verb.base }
    description { Faker::Lorem.paragraph }
    due_date { 14.days.ago }
    completed { false }
  end
end
