module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

      private

      def render_error(status:, code:, message:, details: nil)
        body = { error: code, message: message }
        body[:details] = details if details.present?

        render json: body, status: status
      end

      def render_record_invalid(exception)
        render_error(
          status: :unprocessable_entity,
          code: "validation_error",
          message: "Validation failed",
          details: exception.record.errors.full_messages
        )
      end

      def render_not_found
        render_error(status: :not_found, code: "not_found", message: "Resource not found")
      end

      def render_parameter_missing(exception)
        render_error(status: :bad_request, code: "bad_request", message: exception.message)
      end
    end
  end
end
