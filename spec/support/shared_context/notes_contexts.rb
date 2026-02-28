shared_context 'when user has notes of multiple types' do
  let!(:user_critiques_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
  let!(:user_reviews_notes)   { create_list(:note, 5, :short_content, :review, user: user) }
end

shared_context 'with paginated critiques' do
  let!(:first_page_notes)  { create_list(:note, 5, :short_content, :critique, user: user) }
  let!(:second_page_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
end
