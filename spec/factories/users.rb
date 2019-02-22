FactoryBot.define do 
  factory :user do
    sequence(:name)     { |n| "Name ##{n}" }
    role                { ["manager", "seller"].sample }
    sequence(:login)    { |n| "Login ##{n}" }
    sequence(:password) { |n| "Password ##{n}" }

    # trait :manager do
    #   role { "manager" }
    # end

    # trait :seller do
    #   role { "seller" }
    # end

  end
end
