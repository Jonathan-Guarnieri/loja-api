FactoryBot.define do
  factory :order_item do

    association :product
    association :order

    quantity { Random.rand(1...10) }
    item_price { product.sale_price }

  end
end
