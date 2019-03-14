FactoryBot.define do
  factory :order do
    association :contact
    association :user
    order_type   { [ "purchase","sale" ].sample } # automatizar conforme contact.kind
    status       { [ "budget", "production", "delivered" ].sample } # não colocar canceled, 
    # pois este estatus será usado no teste de update (*ver teste*)                   # mudar isso!
  end
end
