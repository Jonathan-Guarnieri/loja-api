FactoryBot.define do 

  factory :user do
    name                       { Faker::Name.name }
    role                       { "manager" }
    email                      { Faker::Internet.email }
    password                   { Faker::Internet.password(8) }
  end

end
