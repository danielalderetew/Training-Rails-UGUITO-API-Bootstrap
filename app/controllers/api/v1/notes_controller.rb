module Api
  module V1
    class NotesController < ApplicationController
      def index
        render json: notes,
          each_serializer: IndexNoteSerializer,
          adapter: :json,
          meta: pagination_meta(notes) 
      end

      def show
        render json: note, serializer: ShowNoteSerializer
      end

      private

      def notes_params
        params.permit(:type, :order, :page, :page_size)
      end

      def note
        Note.find(params[:id])
      end

      def notes
        Note.where(note_type: notes_params[:type])
            .order(created_at: notes_params[:order] || :desc)
            .page(notes_params[:page])
            .per(notes_params[:page_size] || 10)
      end

      def pagination_meta(collection)
        { 
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count 
        }
      end
    end
  end
end

