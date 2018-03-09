FactoryBot.define do
  factory :hello do
    name 'john'
    initialize_with { new(attributes) }
  end
end