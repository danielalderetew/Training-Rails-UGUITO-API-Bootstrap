module Api
  module V1
    class NotesController < ApplicationController
      def index
        render json: index_note,
               each_serializer: IndexNoteSerializer,
               adapter: :json,
               meta: pagination_meta(index_note)
      end

      def show
       render json: show_note, serializer: ShowNoteSerializer
      end

      private
  
      def index_params
        params.permit(:type, :order, :page, :page_size)
       end

      def show_note
        Note.find_by!(id: params[:id])
      end

      def index_note
        Note.where(note_type: index_params[:type])
          .order(created_at: index_params[:order] || :desc)
          .page(index_params[:page])
          .per(index_params[:page_size] || 10)
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

