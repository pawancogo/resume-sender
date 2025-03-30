# frozen_string_literal: true

class CompaniesController < ApplicationController
  def create
    company = Company.new(permitted_params)
    if company.save
      render_success({ data: company, message: 'Created successfully' }, status: :created)
    else
      render_error({ error: company.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  def index
    render_success({ data: Company.active }, status: :ok)
  end

  private

  def permitted_params
    params.require(:company).permit(:name)
  end
end
