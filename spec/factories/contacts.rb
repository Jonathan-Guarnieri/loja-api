FactoryBot.define do
  factory :contact do
    sequence(:name)     { Faker::Name.unique.name }
    sequence(:address)  { Faker::Address.street_address }
    sequence(:document) { [CPF.generate, CNPJ.generate].sample }
    kind                { ["client", "supplier"].sample }
  end
end
