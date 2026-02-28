require 'rails_helper'

describe Api::V1::NotesController, type: :controller do
  describe 'GET #index' do
    context 'when there is a user logged in' do
      include_context 'with authenticated user'

      context 'when filtering by critique' do
        context 'when there are no critiques' do
          before { get :index, params: { type: :critique } }

          it 'responds with empty array' do
            expect(response_body['notes']).to be_empty
          end

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when there are critiques' do
          let!(:user_critiques_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
          let!(:user_reviews_notes) { create_list(:note, 5, :short_content, :review, user: user) }

          before { get :index, params: { type: :critique } }

          it 'responds with critiques' do
            expect(response_body['notes'].map { |n| n['id'] }).to match_array(user_critiques_notes.map(&:id))
          end

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'when filtering by review' do
        context 'when there are no reviews' do
          before { get :index, params: { type: :review } }

          it 'responds with empty array' do
            expect(response_body['notes']).to be_empty
          end

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'when there are reviews' do
          let!(:user_critiques_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
          let!(:user_reviews_notes) { create_list(:note, 5, :short_content, :review, user: user) }

          before { get :index, params: { type: :review } }

          it 'responds with reviews' do
            expect(response_body['notes'].map { |n| n['id'] }).to match_array(user_reviews_notes.map(&:id))
          end

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context 'when filtering using order param' do
        let!(:user_critiques_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
        let!(:user_reviews_notes) { create_list(:note, 5, :short_content, :review, user: user) }

        context 'when order is asc' do
          before { get :index, params: { order: :asc } }

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end

          it 'responds with notes in ascending order' do
            notes = response_body['notes']
            dates = notes.map { |n| DateTime.parse(Note.find(n['id']).created_at.to_s) }
            expect(dates).to eq(dates.sort)
          end
        end

        context 'when order is desc' do
          before { get :index, params: { order: :desc } }

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end

          it 'responds with notes in descending order' do
            notes = response_body['notes']
            dates = notes.map { |n| DateTime.parse(Note.find(n['id']).created_at.to_s) }
            expect(dates).to eq(dates.sort.reverse)
          end
        end
      end

      context 'when filtering using pagination params' do
        let!(:first_page_notes) { create_list(:note, 5, :short_content, :critique, user: user) }
        let!(:second_page_notes) { create_list(:note, 5, :short_content, :critique, user: user) }

        context 'when page is 1 and page_size is 5' do
          before { get :index, params: { type: :critique, order: :asc, page: 1, page_size: 5 } }

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end

          it 'responds with critiques' do
            expect(response_body['notes'].map { |n| n['id'] }).to match_array(first_page_notes.map(&:id))
          end
        end

        context 'when page is 2 and page_size is 5' do
          before { get :index, params: { type: :critique, order: :asc, page: 2, page_size: 5 } }

          it 'responds with 200 status' do
            expect(response).to have_http_status(:ok)
          end

          it 'responds with notes in page 2' do
            expect(response_body['notes'].map { |n| n['id'] }).to match_array(second_page_notes.map(&:id))
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
        before { get :show, params: { id: note.id } }

        it 'responds with the note json' do
          expect(response.body).to eq(expected)
        end

        it 'responds with 200 status' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when fetching a invalid note' do
        before { get :show, params: { id: Faker::Number.number } }

        it 'responds with 404 status' do
          expect(response).to have_http_status(:not_found)
        end
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
