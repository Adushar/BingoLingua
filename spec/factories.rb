FactoryBot.define do
  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    trait :admin do
      admin { true }
    end
    trait :demo_mode do
      email { "demo_user@gmail.com" }
    end
  end
end
