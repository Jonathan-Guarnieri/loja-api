FactoryBot.define do
  factory :phone do
    number { Faker::PhoneNumber.cell_phone }
    association :contact 
  end
end
