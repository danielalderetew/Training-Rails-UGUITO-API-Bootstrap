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
    end
  end
end

