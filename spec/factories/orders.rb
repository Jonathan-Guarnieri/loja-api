FactoryBot.define do
  factory :order do
    order_type   { [ "purchase","sale" ].sample } # automatizar conforme contact.kind
    contact_id   { Contact.order(Arel.sql('RANDOM()')).first[:id] } # otimizar?
    user_id      { User.last.id } # tentar acessar o current_user
    status       { [ "budget", "production", "delivered", "canceled" ].sample }
  end
end
