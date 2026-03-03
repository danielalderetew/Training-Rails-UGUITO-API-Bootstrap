FactoryBot.define do
  factory :utility do
    initialize_with do
      klass = type.constantize
      klass.new(attributes)
    end

    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }
    type { Utility.subclasses.map(&:to_s).sample }

    short_content_limit  { Faker::Number.between(from: 50, to: 120) }
    medium_content_limit { Faker::Number.between(from: short_content_limit + 1, to: 300) }
    max_review_words     { Faker::Number.between(from: 1, to: 500) }
  end
end
