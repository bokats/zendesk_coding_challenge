FactoryBot.define do
  factory :tag do
    sequence(:value)
    
    association :source, factory: :organization
  end
end