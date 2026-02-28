shared_context 'when user has notes of multiple types' do
  let!(:user_critiques_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
  let!(:user_reviews_notes)   { create_list(:note, 5, :short_content, :review, user: user) }
end
