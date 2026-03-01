require 'rails_helper'

shared_context 'when user has notes of multiple types' do
  let!(:user_critiques_notes) { create_list(:note, 5, :critique, user: user) }
  let!(:user_reviews_notes)   { create_list(:note, 5, :review, user: user) }
end

describe Api::V1::NotesController, type: :controller do
  describe 'GET #index' do
    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      context 'when filtering by type' do
        context 'when type is critique' do
          context 'when has no notes' do
            before { get :index, params: { type: :critique } }

            it_behaves_like 'returns successful empty notes'
          end

          context 'when has notes' do
            include_context 'when user has notes of multiple types'
            let(:expected_notes) { user_critiques_notes }

            before { get :index, params: { type: :critique } }

            it_behaves_like 'returns successful expected notes'
          end
        end

        context 'when type is review' do
          context 'when has no notes' do
            before { get :index, params: { type: :review } }

            it_behaves_like 'returns successful empty notes'
          end

          context 'when has notes' do
            include_context 'when user has notes of multiple types'
            let(:expected_notes) { user_reviews_notes }

            before { get :index, params: { type: :review } }

            it_behaves_like 'returns successful expected notes'
          end
        end

        # default type is critique
        context 'when type is random' do
          include_context 'when user has notes of multiple types'

          before { get :index, params: { type: 'banana' } }

          it_behaves_like 'returns successful empty notes'
        end
      end

      context 'when filtering using order param' do
        include_context 'when user has notes of multiple types'

        context 'when order is asc' do
          before { get :index, params: { order: :asc, type: :critique } }

          let(:expected_notes) { user_critiques_notes.sort_by(&:created_at) }

          it_behaves_like 'returns successful notes in order'
        end

        context 'when order is desc' do
          before { get :index, params: { order: :desc, type: :critique } }

          let(:expected_notes) { user_critiques_notes.sort_by(&:created_at).reverse }

          it_behaves_like 'returns successful notes in order'
        end

        # default order is desc
        context 'when order is random' do
          include_context 'when user has notes of multiple types'

          before { get :index, params: { order: 'banana', type: :critique } }

          let(:expected_notes) { user_critiques_notes.sort_by(&:created_at).reverse }

          it_behaves_like 'returns successful notes in order'
        end
      end

      context 'when filtering using pagination params' do
        include_context 'when user has notes of multiple types'

        context 'when page_size is 2' do
          context 'when page is 1' do
            before { get :index, params: { order: :asc, page: 1, page_size: 2, type: :critique } }

            it_behaves_like 'responds with ok status'

            it 'responds with 2 notes' do
              expect(response_body['notes'].size).to eq(2)
            end

            it 'responds with total count in meta' do
              expect(response_body['meta']['total_count']).to eq(5)
            end

            it 'responds with total pages in meta' do
              expect(response_body['meta']['total_pages']).to eq(3)
            end

            it 'responds with current page in meta' do
              expect(response_body['meta']['current_page']).to eq(1)
            end
          end

          context 'when page is 3' do
            before { get :index, params: { order: :asc, page: 3, page_size: 2, type: :critique } }

            it_behaves_like 'responds with ok status'

            it 'responds with 1 note' do
              expect(response_body['notes'].size).to eq(1)
            end

            it 'responds with current page in meta' do
              expect(response_body['meta']['current_page']).to eq(3)
            end
          end
        end

        # default page is 1 & page_size is 5
        context 'when page_size and page are random' do
          include_context 'when user has notes of multiple types'

          before { get :index, params: { order: :asc, page: 'banana', page_size: 'banana', type: :critique } }

          it_behaves_like 'responds with ok status'

          it 'responds with 5 notes' do
            expect(response_body['notes'].size).to eq(5)
          end

          it 'responds with current page in meta' do
            expect(response_body['meta']['current_page']).to eq(1)
          end
        end
      end
    end

    context 'when there is not a user logged in' do
      context 'when fetching all the notes for user' do
        before { get :index }

        it_behaves_like 'unauthorized'
      end
    end
  end

  describe 'GET #show' do
    let(:note) { create(:note, user: user) }

    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      let(:expected) { ShowNoteSerializer.new(note, root: false).to_json }

      context 'when fetching a valid note' do
        let(:record) { note }

        before { get :show, params: { id: record.id } }

        it_behaves_like 'basic show endpoint'
      end

      context 'when fetching a invalid note' do
        before { get :show, params: { id: -1 } }

        it_behaves_like 'not found request'
      end
    end

    context 'when there is not a user logged in' do
      context 'when fetching an note' do
        before { get :show, params: { id: Faker::Number.number } }

        it_behaves_like 'unauthorized'
      end
    end
  end

  describe 'POST #create' do
    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      context 'when creating a valid critique' do
        let(:create_params) do
          { note: attributes_for(:note, :critique, word_count: 100, user: user) }
        end

        it_behaves_like 'returns successful created note'
      end

      context 'when creating a valid review' do
        let(:word_count) { user.utility.max_review_words }
        let(:create_params) do
          { note: attributes_for(:note, :review, word_count: word_count, user: user) }
        end

        it_behaves_like 'returns successful created note'
      end

      context 'when content is too long for a review' do
        let(:word_count) { user.utility.max_review_words + 1 }
        let(:create_params) do
          { note: attributes_for(:note, :review, word_count: word_count, user: user) }
        end

        let(:expected_message) { I18n.t('errors.message.review_too_long', count: user.utility.max_review_words) }

        it_behaves_like 'failed with unprocessable entity and message'
      end

      context 'when creating a note with missing params' do
        let(:create_params) do
          {}
        end
        let(:expected_message) { I18n.t('errors.message.params_is_missing') }

        it_behaves_like 'failed with unprocessable entity and message'
      end
    end

    context 'when there is not a user logged in' do
      context 'when creating a note' do
        let(:create_params) do
          { note: { content: Faker::Lorem.sentence, note_type: 'review', title: Faker::Lorem.sentence } }
        end

        before { post :create, params: create_params }

        it_behaves_like 'unauthorized'
      end
    end
  end
end
