FactoryBot.define do
  factory :phone do
    association :contact 
    number { ["49 3553-0000", "54 9-8900-0000"].sample }
  end
end
