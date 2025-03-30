# frozen_string_literal: true

class HumanResourcesController < ApplicationController
  def create
    human_resource = HumanResource.new(permitted_params)
    if human_resource.save
      render_success({ data: human_resource, message: 'Created successfully' }, status: :created)
    else
      render_error({ error: human_resource.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  def index
    render_success({ data: HumanResource.active, message: '' }, status: :ok)
  end

  private

  def permitted_params
    params.require(:human_resource).permit(:name, :email, :company_id)
  end
end
