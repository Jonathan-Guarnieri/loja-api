FactoryBot.define do
  factory :phone do
    number { "49 3553-0000" }
    association :contact 
  end
end
