# frozen_string_literal: true

class ResumeHumanResourceMailer < ApplicationMailer
  def send_resume(user:, hr:)
    resume = user.active_resume
    match = resume.public_url.match(/\/d\/(.*?)\//)
    google_drive_id = match[1] if match
    if google_drive_id.present?

      direct_download_url = "https://drive.google.com/uc?export=download&id=#{google_drive_id}"

      filename = "#{user.name.presence || ""}_resume.pdf"

      begin
        pdf_content = URI.open(direct_download_url).read
        attachments[filename] = pdf_content if pdf_content.present?
      rescue => e
        Rails.logger.error "Failed to download resume: #{e.message}"
      end
    end
    @user = user
    @description = resume.description
    mail(from: "#{user.name} <#{user.email}>", reply_to: user.email, to: hr.email, subject: resume.subject)
  end
end
