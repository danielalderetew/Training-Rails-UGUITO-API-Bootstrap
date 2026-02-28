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
        sanitized_params = params.permit(%i[type order page page_size])

        sanitized_params[:type] = normalize_type(sanitized_params[:type])
        sanitized_params[:order] = normalize_order(sanitized_params[:order])
        sanitized_params[:page] = normalize_page(sanitized_params[:page])
        sanitized_params[:page_size] = normalize_page_size(sanitized_params[:page_size])

        sanitized_params
      end

      def note
        notes.find(params[:id])
      end

      def notes_paginated
        notes.where(note_type: notes_params[:type])
             .order(created_at: notes_params[:order])
             .page(notes_params[:page])
             .per(notes_params[:page_size])
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

      def normalize_type(type)
        return nil unless type.present? && Note.note_types.key?(type)
        type
      end

      def normalize_order(order)
        %w[asc desc].include?(order.to_s.downcase) ? order.to_s.downcase : 'desc'
      end

      def normalize_page(page)
        page.to_i.positive? ? page.to_i : 1
      end

      def normalize_page_size(size)
        size.to_i.positive? ? size.to_i : 10
      end
    end
  end
end
