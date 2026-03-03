module Api
  module V1
    class NotesController < ApplicationController
      before_action :authenticate_user!

      rescue_from ActionController::ParameterMissing, with: :handle_missing_params
      rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
      rescue_from ArgumentError, with: :handle_invalid_note_type

      def create
        notes.create!(note_params)
        render_created
      end

      def index
        notes_show = filtered_notes
        render json: notes_show,
               each_serializer: IndexNoteSerializer,
               adapter: :json,
               meta: pagination_meta(notes_show)
      end

      def index_async
        response = execute_async(RetrieveNotesWorker, current_user.id, index_async_params)
        async_custom_response(response)
      end

      def show
        render json: note, serializer: ShowNoteSerializer
      end

      private

      def notes
        current_user.notes
      end

      def note
        notes.find(params[:id])
      end

      def filtered_notes
        filters = filter_params

        notes.where(note_type: filters[:type])
             .order(created_at: filters[:order])
             .page(filters[:page])
             .per(filters[:page_size])
      end

      def filter_params
        permitted = params.permit(:order, :page, :page_size, :type)

        {
          order: sanitize_order(permitted[:order]),
          page: sanitize_page(permitted[:page]),
          page_size: sanitize_page_size(permitted[:page_size]),
          type: sanitize_type(permitted[:type])
        }
      end

      def sanitize_order(order)
        order = order&.downcase
        %w[asc desc].include?(order) ? order : 'desc'
      end

      def sanitize_page(page)
        page.to_i.positive? ? page.to_i : 1
      end

      def sanitize_page_size(page_size)
        page_size.to_i.positive? ? page_size.to_i : 10
      end

      def sanitize_type(type)
        valid_note_type?(type) ? type : nil
      end

      def note_params
        params.require(:note)
              .permit(:content, :note_type, :title)
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

      def valid_note_type?(type)
        Note.note_types.key?(type)
      end

      def handle_missing_params
        render_error(I18n.t('errors.message.params_is_missing'))
      end

      def handle_invalid_note_type
        render_error(I18n.t('errors.message.invalid_note_type'))
      end

      def handle_record_invalid(exception)
        render_error(exception.record.errors.map(&:message).join(', '))
      end

      def render_error(message)
        render json: { error: message }, status: :unprocessable_entity
      end

      def render_created
        message = I18n.t('notes.created')
        render json: { message: message }, status: :created
      end

      def index_async_params
        { author: params.require(:author) }
      end
    end
  end
end
