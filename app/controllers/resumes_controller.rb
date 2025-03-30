# frozen_string_literal: true

class ResumesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    resume = Resume.new(permitted_params)
    if resume.save
      render json: { data: resume, message: 'Created successfully' }, status: :created
    else
      render json: { error: resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    resume = Resume.find(params[:id].to_i)
    if resume.update(permitted_params)
      render json: { data: resume, message: 'Resume updated successfully' }, status: :ok
    else
      render json: { error: resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:resume).permit(:file, :user_id, :title, :subject, :description, :public_url)
  end
end
