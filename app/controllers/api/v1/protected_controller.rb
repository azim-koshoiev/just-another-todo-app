# frozen_string_literal: true

module Api
  module V1
    class ProtectedController < ApplicationController #:nodoc:
      before_action :authenticate_user!
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      protected

      # override
      def authorized?
        false
      end

      def handle_unauthorized
        respond_to do |format|
          format.json do
            render template: 'api/v1/shared/unauthorized', status: 401
          end
        end
      end

      private

      def record_not_found(error)
        respond_to do |format|
          format.json { render json: error.message, status: :not_found }
        end
      end
    end
  end
end
