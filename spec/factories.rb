FactoryBot.define do
  factory :vending_machine do
    coins_capacity 100
    products_capacity 100
    initialize_with { new(attributes) }
  end

  factory :product do
    sku Random.new.rand(10)
    name 'coke'
    price_in_pence 350
    initialize_with { new(attributes) }
  end
end