module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!
      
      def index
        render json: notes_paginated,
          each_serializer: IndexNoteSerializer,
          adapter: :json,
          meta: pagination_meta(notes_paginated) 
      end

      def show
        render json: note, serializer: ShowNoteSerializer
      end

      private

      def notes
        current_user.notes
      end

      def notes_params
        params.permit(:type, :order, :page, :page_size)
      end

      def note
        notes.find(params[:id])
      end

      def notes_paginated
        notes.where(note_type: notes_params[:type])
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

