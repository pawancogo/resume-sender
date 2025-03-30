# frozen_string_literal: true

module ApiResponder
  extend ActiveSupport::Concern

  def render_success(options = {}, status: :ok)
    data = options[:data] || []
    message = options[:message] || 'success'
    meta = options[:meta] || {}

    render json: {
      success: true,
      data: data,
      meta: meta.merge(message: message, timestamp: Time.current)
    }, status: status
  end

  def render_error(options = {}, status: :unprocessable_entity)
    errors = options[:errors] || []
    message = options[:message] || 'error'
    meta = options[:meta] || {}

    formatted_errors = errors.is_a?(Array) ? errors : [errors]

    render json: {
      success: false,
      errors: formatted_errors,
      meta: meta.merge(message: message, timestamp: Time.current)
    }, status: status
  end
end
