FactoryBot.define do
  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
    confirmed_at { Time.now }
    points { 0 }
    trait :admin do
      admin { true }
    end
    trait :demo_mode do
      email { "demo_user@gmail.com" }
    end
  end
  factory :test, class: Test do
    transient do
      num_cards { 0 } # Not create cards
    end
    # Fill columns
    name { Faker::Book.title }
    free { Faker::Boolean.boolean }

    trait :with_cards do
      num_cards { 100 } # or create if we need
    end
    after(:create) do |test, evaluator|
      create_list(:cards, (evaluator.num_cards), test: test)
    end
  end
  factory :cards, class: Card do
    picture { Faker::File.file_name('/foo/bar', nil, 'mp3') }
    sound { Faker::File.file_name('/foo/bar', nil, 'jpg') }
    translation { Faker::Lorem.word }
    description { Faker::Lorem.word }
  end
  factory :language, class: Language do
    name { Faker::Hacker.noun }
    code { Faker::Hacker.abbreviation }
  end
end
