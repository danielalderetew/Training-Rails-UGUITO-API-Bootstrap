require 'rails_helper'

describe Api::V1::NotesController, type: :controller do
  describe 'GET #index' do
    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      context 'when filtering by type' do
        context 'when type is critique' do
          context 'when has no notes' do
            before { get :index, params: { type: :critique } }

            it_behaves_like 'successful request'
            it_behaves_like 'returns empty notes'
          end

          context 'when has notes' do
            include_context 'when user has notes of multiple types'
            let(:expected_notes) { user_critiques_notes }

            before { get :index, params: { type: :critique } }

            it_behaves_like 'successful request'
            it_behaves_like 'returns expected notes'
          end
        end

        context 'when type is review' do
          context 'when has no notes' do
            before { get :index, params: { type: :review } }

            it_behaves_like 'successful request'
            it_behaves_like 'returns empty notes'
          end

          context 'when has notes' do
            include_context 'when user has notes of multiple types'
            let(:expected_notes) { user_reviews_notes }

            before { get :index, params: { type: :review } }

            it_behaves_like 'successful request'
            it_behaves_like 'returns expected notes'
          end
        end

        # default type is critique
        context 'when type is random' do
          include_context 'when user has notes of multiple types'

          before { get :index, params: { type: 'banana' } }

          it_behaves_like 'successful request'
          it_behaves_like 'returns empty notes'
        end
      end

      context 'when filtering using order param' do
        include_context 'when user has notes of multiple types'

        context 'when order is asc' do
          before { get :index, params: { type: :critique, order: :asc } }

          let(:expected_notes) { user_critiques_notes.sort_by(&:created_at) }

          it_behaves_like 'successful request'
          it_behaves_like 'returns notes in order'
        end

        context 'when order is desc' do
          before { get :index, params: { type: :critique, order: :desc } }

          let(:expected_notes) { user_critiques_notes.sort_by(&:created_at).reverse }

          it_behaves_like 'successful request'
          it_behaves_like 'returns notes in order'
        end

        # default order is desc
        context 'when order is random' do
          include_context 'when user has notes of multiple types'

          before { get :index, params: { type: :critique, order: 'banana' } }

          let(:expected_notes) { user_critiques_notes.sort_by(&:created_at).reverse }

          it_behaves_like 'successful request'
          it_behaves_like 'returns notes in order'
        end
      end

      context 'when filtering using pagination params' do
        include_context 'with paginated critiques'

        context 'when page_size is 2' do
          before { get :index, params: { type: :critique, order: :asc, page: 1, page_size: 2 } }

          it_behaves_like 'successful request'

          it 'responds with 2 notes' do
            expect(response_body['notes'].size).to eq(2)
          end

          it 'responds with total count in meta' do
            expect(response_body['meta']['total_count']).to eq(10)
          end

          it 'responds with total pages in meta' do
            expect(response_body['meta']['total_pages']).to eq(5)
          end

          it 'responds with current page in meta' do
            expect(response_body['meta']['current_page']).to eq(1)
          end
        end

        context 'when page is 1 and page_size is 5' do
          let(:expected_notes) { first_page_notes }

          before { get :index, params: { type: :critique, order: :asc, page: 1, page_size: 5 } }

          it_behaves_like 'successful request'
          it_behaves_like 'returns expected notes'
        end

        context 'when page is 2 and page_size is 5' do
          let(:expected_notes) { second_page_notes }

          before { get :index, params: { type: :critique, order: :asc, page: 2, page_size: 5 } }

          it_behaves_like 'successful request'
          it_behaves_like 'returns expected notes'
        end

        # default page_size is 10
        context 'when page_size is random' do
          include_context 'with paginated critiques'

          before { get :index, params: { type: :critique, order: :asc, page: 1, page_size: 'banana' } }

          it_behaves_like 'successful request'

          it 'responds with 10 notes' do
            expect(response_body['notes'].size).to eq(10)
          end
        end

        # default page is 1
        context 'when page is random' do
          include_context 'with paginated critiques'

          before { get :index, params: { type: :critique, order: :asc, page: 'banana', page_size: 5 } }

          it_behaves_like 'successful request'

          it 'responds with 5 notes' do
            expect(response_body['notes'].size).to eq(5)
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
    let(:note) { create(:note, :short_content, user: user) }

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
end
