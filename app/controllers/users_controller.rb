# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: %i[signup signin]

  def signup
    user = User.new(email: permitted_params[:email], password: permitted_params[:password])
    if user.save
      render json: { data: user, message: 'Created successfully' }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def signin
    user = User.find_by_email(permitted_params[:email])
    return render json: { error: 'Email not found' } if user.nil?

    if user&.authenticate(permitted_params[:password])
      token = JwtService.encode(user_id: user.id)
      return render json: { data: user.attributes.merge!(token:), message: 'signed in successfully!' }
    end
    render json: { error: 'Incorrect password' }
  end

  def profile
    render json: @current_user.attributes.merge(resume: @current_user.active_resume)
  end

  private

  def permitted_params
    params.require(:user).permit(:email, :password, :name, :phone_number)
  end
end
