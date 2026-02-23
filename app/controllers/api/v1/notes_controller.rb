module Api
  module V1
    class NotesController < ApplicationController
      def index
       render json: Note.all
      end

      def show
       render json: note
      end

      private
  
      def index_params
        params.permit(:type, :order, :page, :page_size)
       end

      def note
        Note.find_by!(id: params[:id])
      end

    end
  end
end

