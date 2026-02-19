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

  belongs_to :user

 

end
