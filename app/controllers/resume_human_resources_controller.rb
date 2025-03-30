# frozen_string_literal: true

require 'csv'
class ResumeHumanResourcesController < ApplicationController
  def create
    if permitted_params[:bulk_upload]
      file = permitted_params[:file]

      return render json: { error: 'No file uploaded' }, status: :bad_request if file.nil?

      unless csv_file?(file)
        return render json: { error: 'Invalid file format. Please upload a CSV file.' }, status: :unprocessable_entity
      end

      begin
        process_csv(file)
        render json: { message: 'CSV processed successfully' }, status: :ok
      rescue StandardError => e
        render json: { error: "Error processing CSV: #{e.message}" }, status: :unprocessable_entity
      ensure
        file.tempfile.unlink if file.respond_to?(:tempfile)
      end
    else
      hr_process(permitted_params)
      render json: { message: 'Mail sent successfully' }, status: :ok
    end
  end

  def index
    data = @current_user.active_resume.resume_human_resources
    render_success({ data: }, status: :ok)
  end

  private

  def permitted_params
    params.require(:resume_human_resource).permit(:human_resource_id, :resume_id, :status, :file, :bulk_upload, :email)
  end

  def process_csv(file)
    CSV.foreach(file.path, headers: true) do |row|
      # we can limit here as well by breaking down in batches to give smooth response
      # Convert row to hash
      hr_data = row.to_h.symbolize_keys
      hr_process(hr_data)
    end
  end

  def csv_file?(file)
    file.content_type == 'text/csv' || File.extname(file.original_filename).downcase == '.csv'
  end

  def hr_process(hr_data)
    hr = HumanResource.find_or_initialize_by(email: hr_data[:email])
    company = hr_data[:company].present? ? Company.find_or_create_by(name: hr_data[:company]) : nil
    hr.company_id = company.id if company.present?
    hr.phone_number = hr_data[:phone_number] if hr_data[:phone_number].present?
    hr.save

    rhr = ResumeHumanResource.find_or_initialize_by(human_resource_id: hr.id, resume_id: @current_user.active_resume.id)
    rhr.update(applied_at: DateTime.now, status: :pending)
    ResumeHumanResourceMailer.send_resume(user: @current_user, hr:).deliver_now!
  end
end
