FactoryBot.define do
  factory :note do
    title { Faker::Book.title }
    content { Faker::Lorem.words(number: word_count).join(' ') }
    note_type { :critique }
    user

    transient do
      word_count { 10 }
    end

    trait :review do
      note_type { :review }
    end

    trait :critique do
      note_type { :critique }
    end
  end
end
