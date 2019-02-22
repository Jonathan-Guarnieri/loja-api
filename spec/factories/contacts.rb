FactoryBot.define do
  factory :contact do
    sequence(:name)     { |n| "Name ##{n}" }
    sequence(:address)    { |n| "Address ##{n}" }
    sequence(:document) { [CPF.generate, CNPJ.generate].sample }
    kind                { ["client", "supplier"].sample }
  end
end
