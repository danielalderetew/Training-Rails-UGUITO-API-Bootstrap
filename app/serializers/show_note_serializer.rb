class ShowNoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :type, :word_count, :content_length
  belongs_to :user, serializer: UserSerializer

  def type
    object.note_type
  end
end
