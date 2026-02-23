class ShowNoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :note_type, :word_count, :content_length
  belongs_to :user, serializer: UserSerializer
end
