FactoryBot.define do
  factory :note do
    title { Faker::Book.title }
    note_type { :critique }
    user

    trait :review do
      note_type { :review }
    end

    trait :critique do
      note_type { :critique }
    end

    trait :long_content do
      content do
        limit_min = user.utility.medium_content_limit + 1
        limit_max = user.utility.medium_content_limit + 80
        Faker::Lorem.words(number: rand(limit_min..limit_max)).join(" ")
      end
    end
    

    trait :medium_content do
      content do
        limit_max = user.utility.medium_content_limit
        limit_min = user.utility.short_content_limit
        Faker::Lorem.words(number: rand(limit_min+1..limit_max)).join(" ")
      end
    end

    trait :short_content do
      content do
        limit_max = user.utility.short_content_limit
        limit_min = 1
        Faker::Lorem.words(number: rand(limit_min..limit_max)).join(" ")
      end
    end

    trait :north do
      association :user, factory: [:user, :north]
    end

    trait :south do
      association :user, factory: [:user, :south]
    end
  end
end
