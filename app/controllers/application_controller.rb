# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApiResponder
  before_action :authorize_request
  # before_action :authenticate_admin!
  protect_from_forgery with: :null_session
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    token = request.headers['AUTHTOKEN'] || request.headers['authtoken'] || params['authtoken']
    begin
      @decoded = JwtService.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
