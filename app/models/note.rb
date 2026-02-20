# == Schema Information
#
# Table name: notes
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  content    :string
#  user_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_type  :integer          default("critique")
#
class Note < ApplicationRecord
  enum note_type: { critique: 0, review: 1 }

  validates :title, :content, :note_type,
            presence: true

  validate :validate_review_content

  belongs_to :user

  def word_count
    content.split.count
  end

  def validate_review_content
    return unless review?
    return unless user&.utility

    max_review_words = user.utility.max_review_words

    unless word_count <= max_review_words
      errors.add(:content, "Review must have at most #{max_review_words} words")
    end
  end
  
end
