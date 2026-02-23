FactoryBot.define do
  factory :note do
    title { Faker::Book.title }
    content { Faker::Lorem.words(number: 50).join(" ") }
    note_type { :critique }
    user

    trait :review do
      note_type { :review }
    end

    trait :critique do
      note_type { :critique }
    end

    trait :long_content do
      content { Faker::Lorem.words(number: 150).join(" ") }
    end

    trait :medium_content_north do
      content { Faker::Lorem.words(number: 55).join(" ") }
    end

    trait :medium_content_south do
      content { Faker::Lorem.words(number: 65).join(" ") }
    end

    trait :short_content do
      content { Faker::Lorem.words(number: 10).join(" ") }
    end

    trait :north do
      association :user, factory: [:user, :north]
    end

    trait :south do
      association :user, factory: [:user, :south]
    end
  end
end
