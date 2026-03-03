FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    document_number { Faker::IDNumber.valid }
    utility

    trait :north do
      association :utility, factory: :north_utility
    end

    trait :south do
      association :utility, factory: :south_utility
    end
  end
end
