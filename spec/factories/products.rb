FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    purchase_price { Random.rand(1.00...2.00).round(2) }
    sale_price { Random.rand(3.00...4.00).round(2) }
    amount { Random.rand(1...100) }
  end
end
