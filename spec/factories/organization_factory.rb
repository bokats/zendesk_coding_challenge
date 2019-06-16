FactoryBot.define do
  factory :organization do
    sequence(:url)
    shared_tickets true

    trait :with_tags do
      after(:create) do |organization|
        create(:tag, value: 'test', source: organization)
      end
    end
  end
end